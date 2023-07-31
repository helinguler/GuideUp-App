import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/pages/guide/card/gude_card.dart';
import 'package:guide_up/service/post/post_service.dart';
import 'package:guide_up/ui/material/custom_material.dart';

import '../../core/constant/color_constants.dart';
import '../../core/utils/secure_storage_helper.dart';

class GuideHomePage extends StatefulWidget {
  const GuideHomePage({Key? key}) : super(key: key);

  @override
  State<GuideHomePage> createState() => _GuideHomePageState();
}

class _GuideHomePageState extends State<GuideHomePage> {
  bool _isLogIn = false;
  String _userId = "";
  bool _refresh = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getUserDetail();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_refresh) {
      if (_scrollController.offset ==
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {});
      }
      _refresh = !_refresh;
    } else {
      _refresh = !_refresh;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack,
        flexibleSpace: CustomMaterial.appBarFlexibleSpace,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: ColorConstants.appBarTitleGradientColors,
            ).createShader(bounds);
          },
          child: Text('G u i d e',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textwhite,
                ),
              )),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        ColorConstants.buttonPurple,
                        ColorConstants.buttonPink
                      ],
                    ).createShader(bounds);
                  },
                  child: IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh))),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: CustomMaterial.backgroundBoxDecoration,
        child: FutureBuilder(
          builder: (context2, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Guidleri şu an listeyemiyoruz.'),
              );
            } else {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (context3, index) {
                    final postCardView = snapshot.data![index];
                    return GuideCard(
                      postCardView: postCardView,
                      userId: _userId,
                    );
                  },
                  itemCount: snapshot.data!.length,
                  controller: _scrollController,
                );
              } else {
                return const Center(
                  child: Text('Hiç Guide Bulunamadı :('),
                );
              }
            }
          },
          future: PostService().getList(_userId, 0),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _isLogIn,
        child: FloatingActionButton(
          backgroundColor: ColorConstants.darkBack,
          // Buton kutusu arka plan rengi
          tooltip: "Guide Ekle",
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.pushNamed(context, RouterConstants.guideAdd)
                .then((value) {
              setState(() {});
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        ColorConstants.buttonPurple,
                        ColorConstants.buttonPink
                      ],
                    ).createShader(bounds);
                  },
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouterConstants.guideAdd)
                          .then((value) {
                        setState(() {});
                      });
                    },
                    icon: const Icon(Icons.add),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void getUserDetail() async {
    UserDetail? detail = await SecureStorageHelper().getUserDetail();
    if (detail == null) {
      detail = null;
    } else {
      _userId = detail.getUserId()!;
      _isLogIn = true;
      setState(() {});
    }
  }
}
