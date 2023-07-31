import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/core/dto/post/post_card_view.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/pages/guide/card/guide_comment_card.dart';
import 'package:guide_up/service/post/comment/comment_service.dart';
import 'package:guide_up/service/post/post_categories_service.dart';

import '../../core/constant/color_constants.dart';
import '../../core/utils/secure_storage_helper.dart';
import '../../ui/material/custom_material.dart';

class GuideDetailPage extends StatefulWidget {
  const GuideDetailPage({Key? key}) : super(key: key);

  @override
  State<GuideDetailPage> createState() => _GuideDetailPageState();
}

class _GuideDetailPageState extends State<GuideDetailPage> {
  late PostCardView _postCardView;
  UserDetail? _userDetail;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  void getUserDetail() async {
    UserDetail? detail = await SecureStorageHelper().getUserDetail();
    if (detail == null) {
      detail = null;
    } else {
      _userDetail = detail;
      _userId = detail.getUserId()!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _postCardView = ModalRoute.of(context)!.settings.arguments as PostCardView;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.background,
        title: const Text('Guide'),
      ),
      body: Container(
        decoration: CustomMaterial.backgroundBoxDecoration,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ('${_postCardView.topic}'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ('${_postCardView.content}'),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              if (_postCardView.isThereCategory)
                FutureBuilder(
                  future: PostCategoriesService()
                      .getCategoryListByPostCategoriesPostId(_postCardView.id!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final title = snapshot.data!.map((e) => e.getName());
                      return Text("Kategoriler: ${title.toString().replaceAll('(', '').replaceAll(')', '')}");
                    } else {
                      return const Text("");
                    }
                  },
                ),
              const SizedBox(height: 16),
              if (_postCardView.photo != null)
                Image.network(
                  _postCardView.photo!,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 16),
              Text(
                'Yorumlar:',
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: ColorConstants.itemWhite,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder(
                future: CommentService().getList(_postCardView.id!, 0, _userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Yorumlara erişirken hata ile karşılaşıldı.',
                        style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.itemWhite,
                          ),
                        ),
                      ),
                    );
                  } else {
                    if ((snapshot.data != null && snapshot.data!.isEmpty)) {
                      return Center(
                        child: Text(
                          'Hiç yorum yok',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.itemWhite,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var commend = snapshot.data![index];
                          return GuideCommentCard(
                              commentCardView: commend, userId: _userId);
                        },
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              Visibility(
                visible: _userDetail != null,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                            context, RouterConstants.guideCommentPage,
                            arguments: _postCardView)
                        .then((value) {
                      setState(() {});
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shadowColor: ColorConstants.buttonPurple,
                      elevation: 18,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [ColorConstants.buttonPurple,ColorConstants.buttonPink]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: 400,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Text(
                        'Yorum Ekle',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
