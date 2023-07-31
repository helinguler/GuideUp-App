import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/enumeration/extensions/ExLinkType.dart';
import 'package:guide_up/core/models/users/user_detail/user_categories_model.dart';
import 'package:guide_up/core/utils/user_info_helper.dart';
import 'package:guide_up/pages/profile/my_profile/link_add_dialog.dart';
import 'package:guide_up/repository/user/user_detail/user_categories_repository.dart';
import 'package:guide_up/service/user/user_detail/user_categories_service.dart';
import 'package:guide_up/service/user/user_detail/user_detail_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../core/constant/color_constants.dart';
import '../../../core/constant/router_constants.dart';
import '../../../core/models/users/user_detail/user_detail_model.dart';
import '../../../core/models/users/user_model.dart';
import '../../../core/utils/control_helper.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../repository/user/user_detail/user_links_repository.dart';
import '../../../repository/user/user_repository.dart';
import '../../../ui/material/custom_material.dart';
import '../../category/category_list.dart';
import '../../category/helper/category_select_helper.dart';

class MyProfileAccount extends StatefulWidget {
  const MyProfileAccount({Key? key}) : super(key: key);

  @override
  State<MyProfileAccount> createState() => _MyProfileAccountState();
}

class _MyProfileAccountState extends State<MyProfileAccount> {
  UserDetail? userDetail;
  UserModel? userModel;
  String profileImagePath = "";
  DateTime selectedDate = DateTime.now();
  final dateFormat = DateFormat('dd.MM.yyyy');
  bool _isMentor = false;
  List<Map<String, String>> otherLinks = [];
  List<String> educationInfo = [];
  List<String> experienceInfo = [];
  List<String> projectInfo = [];
  List<String> skillsInfo = [];

  final _aboutController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  Country? selectedPhoneCountry;

  // ignore: prefer_typing_uninitialized_variables
  late final _birthdayController;

  @override
  void initState() {
    super.initState();
    _birthdayController = TextEditingController(
      text: dateFormat.format(selectedDate),
    );

    getUserModels();
  }

  void getUserModels() async {
    UserDetail? detail = await SecureStorageHelper().getUserDetail();
    if (detail == null) {
      detail = null;
    } else {
      userDetail = detail;
      _isMentor = userDetail!.isMentor();
      UserModel? model =
          await UserRepository().getUserByUserId(detail.getUserId()!);
      if (model == null) {
        userModel = null;
      } else {
        setState(() {
          userModel = model;
          setValues();
        });
      }
    }
  }

  Future<void> pickProfileImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);
    if (pickedImage != null) {
      profileImagePath = pickedImage.path;
      userDetail = await UserDetailService()
          .updateUserPhotoByPathAndUserDetail(profileImagePath, userDetail!);
      setState(() {});
    }
    setState(() {});
  }

  Future<void> showDatePickerDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: ColorConstants.theme1DarkBlue,
              ),
              dialogBackgroundColor: ColorConstants.textwhite),
          child: child ?? const Text(""),
        );
      },
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _birthdayController.text = dateFormat.format(selectedDate);
      });
    }
  }

  void addOtherLink() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LinkAddDialog(
          userDetail: userDetail!,
        );
      },
    ).then((value) {
      Future.delayed(const Duration(seconds: 2));
      setState(() {});
    });
  }

  void removeOtherLink(int index) {
    setState(() {
      otherLinks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: ColorConstants.darkBack,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              ListView(
                children: [
                  Center(
                    child: Text(
                      "Profilim",
                      style: GoogleFonts.nunito(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textwhite),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: pickProfileImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundColor: ColorConstants.buttonPurple,
                          // Arka plan rengi
                          backgroundImage:
                              UserInfoHelper.getProfilePicture(userDetail),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    minLines: 2,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Hakkımda',
                      labelStyle: GoogleFonts.nunito(
                        color: (_aboutController.value.text.isNotEmpty)
                            ? ColorConstants.appcolor2
                            : ColorConstants.background,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (_aboutController.value.text.isNotEmpty)
                              ? ColorConstants.appcolor2
                              : ColorConstants.background,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    controller: _aboutController,
                    cursorColor: ColorConstants.appcolor2,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'İsim',
                      labelStyle: GoogleFonts.nunito(
                        color: (_nameController.value.text.isNotEmpty)
                            ? ColorConstants.appcolor2
                            : ColorConstants.background,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (_nameController.value.text.isNotEmpty)
                              ? ColorConstants.appcolor2
                              : ColorConstants.background,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    cursorColor: ColorConstants.appcolor2,
                    controller: _nameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Soyisim',
                      labelStyle: GoogleFonts.nunito(
                        color: (_lastnameController.value.text.isNotEmpty)
                            ? ColorConstants.appcolor2
                            : ColorConstants.background,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (_lastnameController.value.text.isNotEmpty)
                              ? ColorConstants.appcolor2
                              : ColorConstants.background,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    cursorColor: ColorConstants.appcolor2,
                    controller: _lastnameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      labelStyle: GoogleFonts.nunito(
                        color: (_usernameController.value.text.isNotEmpty)
                            ? ColorConstants.appcolor2
                            : ColorConstants.background,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (_usernameController.value.text.isNotEmpty)
                              ? ColorConstants.appcolor2
                              : ColorConstants.background,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    cursorColor: ColorConstants.appcolor2,
                    controller: _usernameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Doğum Tarihi',
                      labelStyle: GoogleFonts.nunito(
                        color: ColorConstants.appcolor2,
                      ),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: showDatePickerDialog,
                        color: ColorConstants.appcolor2,
                      ),
                    ),
                    readOnly: true,
                    controller: _birthdayController,
                  ),
                  const SizedBox(height: 16.0),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Telefon Numarası',
                      // Telefon numarası alanının etiketi
                      labelStyle: GoogleFonts.nunito(
                        color: (_phoneController.value.text.isNotEmpty)
                            ? ColorConstants.appcolor2
                            : ColorConstants.background,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Kenarlık şeklini ayarla
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (_phoneController.value.text.isNotEmpty)
                              ? ColorConstants.appcolor2
                              : ColorConstants.background,
                        ),
                        borderRadius: BorderRadius.circular(
                            8.0), // Fokuslanmış kenarlık şeklini ayarla
                      ),
                    ),
                    controller: _phoneController,
                    // Telefon numarası değerini tutmak için bir controller atanır
                    initialCountryCode: 'TR',
                    // İlk açıldığında görünecek ülke kodu
                    onCountryChanged: (value) {
                      selectedPhoneCountry = value;
                      if (value.code != "TR") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Türkiye dışındaki ülkeler şimdilik kayıt edilemiyor.")),
                        );
                      }
                    },
                    onChanged: (phone) {
                      setState(() {
                        //_phoneController.text = phone.completeNumber;  // Telefon numarası değiştiğinde controller'ı güncelle
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      enabled: false,
                      labelText: 'E-posta',
                      labelStyle: GoogleFonts.nunito(
                        color: (_emailController.value.text.isNotEmpty)
                            ? ColorConstants.appcolor2
                            : ColorConstants.background,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (_emailController.value.text.isNotEmpty)
                              ? ColorConstants.appcolor2
                              : ColorConstants.background,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    cursorColor: ColorConstants.appcolor2,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                    },
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButton<bool>(
                    focusColor: ColorConstants.buttonPurple,
                    value: _isMentor,
                    iconSize: 40,
                    style:
                        GoogleFonts.nunito(color: ColorConstants.buttonPurple),
                    dropdownColor: ColorConstants.background,
                    iconEnabledColor: ColorConstants.background,
                    isExpanded: true,
                    onChanged: (bool? value) {
                      _isMentor = value!;
                      setState(() {});
                    },
                    items:
                        [true, false].map<DropdownMenuItem<bool>>((bool value) {
                      return DropdownMenuItem<bool>(
                        value: value,
                        child: Text(value ? "Mentor" : "Mentee"),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Veriler alınırken bir hata oluştu.',
                            style: GoogleFonts.nunito(),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: (snapshot.data!.length) * 85,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final link = snapshot.data![index];
                              return ListTile(
                                onTap: () {},
                                title: Text(link.getLink()!),
                                subtitle: Text(
                                    link.getEnLinkType()!.getDisplayName()),
                                leading: UserInfoHelper.getEnLinkTypeIcon(
                                    link.getEnLinkType()!),
                                trailing: GestureDetector(
                                  onTap: () {
                                    UserLinksRepository().delete(link);
                                    setState(() {});
                                  },
                                  child: Icon(Icons.delete),
                                ),
                              );
                            },
                            itemCount: snapshot.data!.length,
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        );
                      }
                    },
                    future: UserLinksRepository().getUserLinksByUserId(
                        userDetail != null ? (userDetail!.getUserId()!) : "1"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 0.0),
                      TextButton(
                        onPressed: addOtherLink,
                        child: Text(
                          "+ Link Ekle",
                          style: GoogleFonts.nunito(
                            color: ColorConstants.buttonPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 0.0),
                      Column(
                        children: otherLinks.asMap().entries.map((entry) {
                          final index = entry.key;
                          final link = entry.value;

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorConstants.background,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  link['title']!,
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(link['link']!),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        removeOtherLink(index);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: ColorConstants.background,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      showCategoryDialog(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorConstants.background,
                      // Arkaplan rengi
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Kenar yarıçapı
                      ),
                    ),
                    child: Text(
                      "Kategori Ekle",
                      style: GoogleFonts.nunito(
                        color: ColorConstants.textwhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  FutureBuilder(
                    future: UserCategoriesService().getUserCategoriesList(
                        userDetail != null ? userDetail!.getUserId()! : "",0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Kategorileri şu an listeleyemiyoruz.',
                              style: GoogleFonts.nunito()),
                        );
                      } else {
                        return SizedBox(
                          height: snapshot.data!.isNotEmpty ? 40 : 0,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final category = snapshot.data![index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: ColorConstants.background,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    UserCategoriesService()
                                        .delete(category.getId()!,
                                            userDetail!.getUserId()!)
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                            itemCount: snapshot.data!.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          RouterConstants.userEducationInformationList);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorConstants.background,
                      // Arkaplan rengi
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Kenar yarıçapı
                      ),
                    ),
                    child: Text(
                      "Eğitim Bilgileri",
                      style: GoogleFonts.nunito(
                        color: ColorConstants.textwhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouterConstants.userProjectList);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorConstants.background,
                      // Arkaplan rengi
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Kenar yarıçapı
                      ),
                    ),
                    child: Text(
                      "Projelerim",
                      style: GoogleFonts.nunito(
                        color: ColorConstants.textwhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouterConstants.userExperienceMainPage);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorConstants.background,
                      // Arkaplan rengi
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Kenar yarıçapı
                      ),
                    ),
                    child: Text(
                      "Tecrübelerim",
                      style: GoogleFonts.nunito(
                        color: ColorConstants.textwhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouterConstants.userAbilities);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorConstants.background,
                      // Arkaplan rengi
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Kenar yarıçapı
                      ),
                    ),
                    child: Text(
                      "Yetenekler",
                      style: GoogleFonts.nunito(
                        color: ColorConstants.textwhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouterConstants.licensesAndCertificatesPage);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorConstants.background,
                      // Arkaplan rengi
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Kenar yarıçapı
                      ),
                    ),
                    child: Text(
                      "Lisanslar ve sertifikalar",
                      style: GoogleFonts.nunito(
                        color: ColorConstants.textwhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                ],
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: ElevatedButton(
                  onPressed: () async {
                    bool continueMethod = true;
                    if (selectedPhoneCountry != null) {
                      if (selectedPhoneCountry!.code != "TR") {
                        continueMethod = false;
                      }
                    }
                    if (continueMethod) {
                      userDetail!.setAbout(_aboutController.value.text);
                      userDetail!.setName(_nameController.value.text);
                      userDetail!.setSurname(_lastnameController.value.text);
                      userModel!.setUsername(_usernameController.value.text);
                      userDetail!.setBirthday(selectedDate);
                      userDetail!.setPhone(_phoneController.value.text);
                      userDetail!.setMentor(_isMentor);
                      try {
                        userDetail = await UserDetailService()
                            .update(userDetail!)
                            .then((value) {
                          CustomMaterial.sendNotification(
                              context, "Kayıt Başarılı");
                          return null;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    } else {}
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorConstants.buttonPurple,
                    backgroundColor: ColorConstants.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Kaydet",
                      style: GoogleFonts.nunito(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 0,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.background,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: ColorConstants.buttonPurple,
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Positioned(
                    top: 7,
                    right: -15,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/logo/guideUpLogoWithBackground.png',
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setValues() {
    _aboutController.text =
        ControlHelper.checkInputValue(userDetail!.getAbout());
    _nameController.text = ControlHelper.checkInputValue(userDetail!.getName());
    _lastnameController.text =
        ControlHelper.checkInputValue(userDetail!.getSurname());
    _emailController.text =
        ControlHelper.checkInputValue(userModel!.getEmail());
    _phoneController.text =
        ControlHelper.checkInputValue(userDetail!.getPhone());
    _usernameController.text =
        ControlHelper.checkInputValue(userModel!.getUsername());
    if (userDetail!.getBirthday() != null) {
      selectedDate = userDetail!.getBirthday()!;
      _birthdayController.text = ControlHelper.checkInputValue(
          dateFormat.format(userDetail!.getBirthday()!));
    }
  }

  void showCategoryDialog(BuildContext mainContext) {
    CategorySelectHelper categorySelectHelper=CategorySelectHelper();
    categorySelectHelper.addListener(() {
      if (categorySelectHelper.categoryList.isNotEmpty) {
        UserCategories usCat = UserCategories();
        usCat.setUserId(userDetail!.getUserId()!);
        usCat
            .setCategoriesId(categorySelectHelper.categoryList.first.getId()!);
        UserCategoriesRepository().add(usCat).then((value) {

          setState(() {});
        });
      }
    });
    showDialog(
      context: mainContext,
      builder: (context) {
        categorySelectHelper.addListener(() {
          if (categorySelectHelper.categoryList.isNotEmpty) {
            categorySelectHelper.categoryList.clear();
            Navigator.pop(context);
            setState(() {});
          }
        });
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
                categorySelectHelper,
              ).getBuildList(mainContext),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
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
                        color: ColorConstants.textwhite,
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
}
