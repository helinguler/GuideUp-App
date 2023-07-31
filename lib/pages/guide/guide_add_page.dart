import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/models/post/post_model.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/core/utils/secure_storage_helper.dart';
import 'package:guide_up/pages/category/category_list.dart';
import 'package:guide_up/repository/post/post_repository.dart';
import 'package:guide_up/service/post/post_service.dart';
import 'package:guide_up/ui/material/custom_material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constant/color_constants.dart';
import '../../core/models/category/category_model.dart';
import '../category/helper/category_select_helper.dart';

class GuideAddPage extends StatefulWidget {
  const GuideAddPage({Key? key}) : super(key: key);

  @override
  State<GuideAddPage> createState() => _GuideAddPageState();
}

class _GuideAddPageState extends State<GuideAddPage> {
  late TextEditingController _topicController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();
  File? _guidePicture;
  Post? post;
  final CategorySelectHelper _categorySelectHelper = CategorySelectHelper();
  List<Category> categoryList = [];

  PostRepository? postRepository;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController();
    _contentController = TextEditingController();

    _categorySelectHelper.addListener(() {
      if (_categorySelectHelper.categoryList.length != categoryList.length) {
        if (categoryList.length > _categorySelectHelper.categoryList.length) {
          CustomMaterial.sendShortNotification(context, "Kategori Çıkarıldı");
        } else if (categoryList.length <
            _categorySelectHelper.categoryList.length) {
          CustomMaterial.sendShortNotification(context, "Kategori Seçildi");
        }
        categoryList.clear();
        categoryList.addAll(_categorySelectHelper.categoryList);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _topicController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void createPost(BuildContext context) async {
    UserDetail? detail = await SecureStorageHelper().getUserDetail();
    if (detail != null) {
      String topic = _topicController.text;
      String content = _contentController.text;

      if (topic.isEmpty || content.isEmpty) {
        CustomMaterial.sendNotification(context, "Tüm Alanları doldurunuz.");
      } else {
        post ??= Post();
        post!.setTopic(topic);
        post!.setContent(content);
        if (_guidePicture != null) {
          post!.setPhoto(_guidePicture!.path);
        }

        if(categoryList.isNotEmpty){
          post!.setThereCategory(true);
        }

        post!.setUserId(detail.getUserId()!);

        PostService().add(post!,categoryList).then((value) {
          Navigator.pop(context);
        });
      }
    }
  }

  pickProfileImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedImage != null) {
      setState(() {
        _guidePicture = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.background,
        centerTitle: true,
        title: Text(
          "Guide 'in",
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              color: ColorConstants.textwhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: ColorConstants.textwhite,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: CustomMaterial.backgroundBoxDecoration,
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Başlık Giriniz ',
                    labelStyle: GoogleFonts.nunito(
                      color: (_topicController.value.text.isNotEmpty)
                          ? ColorConstants.buttonPurple
                          : ColorConstants.buttonPink,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: (_topicController.value.text.isNotEmpty)
                            ? ColorConstants.buttonPurple
                            : ColorConstants.buttonPink,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  controller: _topicController,
                  cursorColor: ColorConstants.buttonPurple,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Metin Giriniz',
                      labelStyle: GoogleFonts.nunito(
                        color: (_contentController.value.text.isNotEmpty)
                            ? ColorConstants.buttonPurple
                            : ColorConstants.buttonPink,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (_contentController.value.text.isNotEmpty)
                              ? ColorConstants.buttonPurple
                              : ColorConstants.buttonPink,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20)),
                  maxLines: 5,
                  minLines: 2,
                  controller: _contentController,
                  cursorColor: ColorConstants.textwhite,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: pickProfileImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image(
                        image: getImage(),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                ElevatedButton(
                  onPressed: () {
                    showCategoryDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorConstants.buttonPurple,
                    elevation: 5,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ColorConstants.buttonPurple,
                          ColorConstants.buttonPink
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        'Kategori Ekle',
                        style: GoogleFonts.nunito(
                            color: ColorConstants.itemWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: categoryList.isNotEmpty ? 40 : 0,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final category = categoryList[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: ColorConstants.background, //güzel gözüktü dokunmadım
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            _categorySelectHelper.removeCategory(category);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(""),
                                Text(
                                  category.getName()!,
                                  style: GoogleFonts.nunito(
                                    color: ColorConstants.appcolor1,
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Icon(
                                  Icons.clear,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    padding: EdgeInsets.all(0),
                    itemCount: categoryList.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    createPost(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorConstants.buttonPurple,
                    elevation: 5,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ColorConstants.buttonPurple,
                          ColorConstants.buttonPink
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        'Guide Ekle',
                        style: GoogleFonts.nunito(
                            color: ColorConstants.itemWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showCategoryDialog(BuildContext mainContext) {
    showDialog(
      context: mainContext,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstants.background,
            centerTitle: true,
            title: Text(
              "Kategori Seçini",
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: ColorConstants.itemWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              CategoryList(
                _categorySelectHelper,
              ).getBuildList(mainContext),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: ColorConstants.buttonPink,
                  elevation: 18,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                       ColorConstants.buttonPink,
                        ColorConstants.buttonPurple,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Text(
                      'Kapat',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider<Object> getImage() {
    if (post == null) {
      if (_guidePicture != null) {
        return FileImage(_guidePicture!);
      } else {
        return const AssetImage("assets/img/Guide_photo_add.png");
      }
    } else {
      return NetworkImage(post!.getPhoto()!,);
    }
  }
}
