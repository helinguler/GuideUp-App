import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/core/utils/secure_storage_helper.dart';
import 'package:guide_up/pages/mentor/card_pages/mentor_card.dart';
import 'package:guide_up/service/user/user_service.dart';
import 'package:guide_up/service/user/user_token_service.dart';
import 'package:guide_up/ui/material/custom_material.dart';

import '../../core/constant/navigation_constants.dart';
import '../../core/utils/user_info_helper.dart';
import '../../service/mentor/mentor_service.dart';


class HomeScreen extends StatefulWidget {
  final GlobalKey<CurvedNavigationBarState> navigationKey;

  const HomeScreen({Key? key, required this.navigationKey}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(navigationKey);
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<CurvedNavigationBarState> navigationKey;
  UserDetail? userDetail;

  _HomeScreenState(this.navigationKey);

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
      userDetail = detail;
      UserTokenService().setToken(userDetail!.getUserId()!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack,
        flexibleSpace: CustomMaterial.appBarFlexibleSpace,
        automaticallyImplyLeading: false,
        title: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: ColorConstants.appBarTitleGradientColors,
            ).createShader(bounds);
          },
          child: Text('G u i d e  U p',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textwhite,
                ),
              )),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (await UserService().checkUser()) {
                Navigator.pushNamed(context, RouterConstants.profilePage);
              } else {
                Navigator.pushNamed(context, RouterConstants.loginPage);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: ColorConstants.darkBack,
                backgroundImage: UserInfoHelper.getProfilePicture(userDetail),
              ),
            ),
          ),
        ],
      ),
      body: Container(
          color: ColorConstants.darkBack,
          //decoration: CustomMaterial.backgroundBoxDecoration,
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      items: [
                        Image.asset('assets/img/homepage1.png'),
                        Image.asset('assets/img/homepage2.png'),
                        Image.asset('assets/img/homepage3.png'),
                        Image.asset('assets/img/homepage4.jpg'),
                      ],
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        autoPlay: true,
                        height: 250,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'En Sevilen Mentorlar',
                          style: TextStyle(
                              color: ColorConstants.textwhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        TextButton(
                          onPressed: () {
                            final navigationState = navigationKey.currentState!;
                            navigationState
                                .setPage(NavigationConstants.searchPageIndex);
                          },
                          child: ShaderMask(
                            blendMode: BlendMode.srcATop,
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [
                                  ColorConstants.buttonPurple,
                                  ColorConstants.buttonPink
                                ],
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'Hepsini Gör',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('Mentorları şu an listeyemiyoruz.'),
                            );
                          } else {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                final mentor = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RouterConstants.mentorPreview,
                                        arguments: mentor);
                                  },
                                  child: MentorCard(mentor: mentor),
                                );
                              },
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                            );
                          }
                        },
                        future: MentorService().getTopMentorList(5),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Yaklaşan Etkinlikler',
                      style: TextStyle(
                        color: ColorConstants.textwhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    CarouselSlider(
                      items: [
                        Image.asset('assets/img/yaklasanetkinlikler1.jpg'),
                        Image.asset('assets/img/yaklasanetkinlikler2.jpg'),
                        Image.asset('assets/img/yaklasanetkinlikler3.jpg'),
                        Image.asset('assets/img/yaklasanetkinlikler4.jpg'),
                      ],
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        autoPlay: true,
                        height: 250,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Senin için Önerilenler',
                          style: TextStyle(
                              color: ColorConstants.textwhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('Mentorları şu an listeyemiyoruz.'),
                            );
                          } else {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                final mentor = snapshot.data![index];
                                return MentorCard(mentor: mentor);
                              },
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                            );
                          }
                        },
                        future: MentorService().getTopMentorList(5),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
