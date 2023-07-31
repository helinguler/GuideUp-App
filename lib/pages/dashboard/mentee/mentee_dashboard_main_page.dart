import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/core/models/mentor/mentee_model.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/core/utils/secure_storage_helper.dart';
import 'package:guide_up/repository/mentee/mentee_repository.dart';
import 'package:guide_up/repository/mentor/mentor_comment_repository.dart';
import 'package:guide_up/repository/mentor/mentor_favourite_repository.dart';
import 'package:guide_up/service/mentee/mentee_service.dart';

import '../../../core/utils/user_helper.dart';
import '../../../core/utils/user_info_helper.dart';
import '../../../service/mentor/mentor_comment_service.dart';
import '../../../ui/material/custom_material.dart';
import '../../mentor/card_pages/mentor_comments_card.dart';

enum EnCardType { mentor, favourite, comment, payment }

class MenteeDashboardMainPage extends StatefulWidget {
  const MenteeDashboardMainPage({super.key});

  @override
  State<MenteeDashboardMainPage> createState() =>
      _MenteeDashboardMainPageState();
}

class _MenteeDashboardMainPageState extends State<MenteeDashboardMainPage> {
  UserDetail? userDetail;
  Mentee? mentee;

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
      mentee = await MenteeRepository().getMenteeByUserId(detail.getUserId()!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkBack,
      body: SafeArea(
        child: Column(
          children: [
            // Mentee'nin profil fotoğrafı
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorConstants.background,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: ColorConstants.background.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          UserInfoHelper.getProfilePicture(userDetail),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        userDetail != null
                            ? (" ${userDetail!.getName() ?? ""} ${userDetail!.getSurname() ?? ""}")
                            : "",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: ColorConstants.textwhite,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${UserHelper().auth.currentUser!.email}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ColorConstants.textwhite,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              width: 330,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorConstants.background,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstants.background.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('İstatistikler',
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                        fontSize: 24,
                      ))),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Süre(Duration)

                      ...createAnalysisCard(
                          "Mentorlarım", EnCardType.mentor, context),

                      // Favoriler
                      ...createAnalysisCard(
                          "Favorilerim", EnCardType.favourite, context),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Yorumlar
                      ...createAnalysisCard(
                          "Yorumlarım", EnCardType.comment, context),

                      // Ödemeler
                      ...createAnalysisCard(
                          "Ödemeler", EnCardType.payment, context),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Yorumlarım',
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(
              child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Yorumları şu an listeleyemiyoruz.',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textwhite,
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final mentorCommentCardViews = snapshot.data![index];
                        return MentorCommentsCard(
                            mentorCommentCardView: mentorCommentCardViews);
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Hiç yorum bulunamadı",
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textwhite,
                        ),
                      ),
                    );
                  }
                },
                future:
                    MentorCommentService().getListByMenteeId(getMenteeId(), 7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUserId() {
    if (userDetail != null) {
      return userDetail!.getUserId()!;
    } else {
      return "";
    }
  }

  List<Widget> createAnalysisCard(
      String title, EnCardType cardType, BuildContext context) {
    return [
      getAvatar(cardType, context),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: getFutureCount(cardType),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Veriler henüz yüklenmediyse, bekleme göster
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Hata oluştuysa, hata mesajını göster
                return Text(
                  '  0',
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                // Veriler hazırsa, sayıyı göster
                final dynamic count = snapshot.data ?? 0;
                return Text(
                  '  $count',
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              '$title',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Future<dynamic> getFutureCount(EnCardType cardType) async {
    if (cardType == EnCardType.mentor) {
      return MenteeRepository().getMenteeListCountByUserId(getUserId());
    } else if (cardType == EnCardType.comment) {
      return MentorCommentRepository()
          .getMentorCommentListCountByMenteeId(getMenteeId());
    } else if (cardType == EnCardType.favourite) {
      return MentorFavouriteRepository()
          .getMentorFavouriteListCountByUserId(getUserId());
    } else if (cardType == EnCardType.payment) {
      return MenteeService().getTotalPriceByUserId(getUserId());
    }

    return 0;
  }

  Widget getAvatar(EnCardType cardType, BuildContext context) {
    switch (cardType) {
      case EnCardType.mentor:
        return CircleAvatar(
          backgroundColor: ColorConstants.textwhite,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouterConstants.menteeMyMentorPage);
            },
            child: const Icon(
              Icons.timeline,
              color: ColorConstants.success,
            ),
          ),
        );
      case EnCardType.favourite:
        return CircleAvatar(
          backgroundColor: ColorConstants.textwhite,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context, RouterConstants.menteeFavouriteMentorPage);
            },
            child: const Icon(
              Icons.person,
              color: ColorConstants.warningDark,
            ),
          ),
        );
      case EnCardType.comment:
        return CircleAvatar(
          backgroundColor: ColorConstants.textwhite,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouterConstants.menteeComentsPage,
                  arguments: mentee);
            },
            child: const Icon(
              Icons.chat,
              color: ColorConstants.theme1Mustard,
            ),
          ),
        );
      case EnCardType.payment:
        return CircleAvatar(
          backgroundColor: ColorConstants.textwhite,
          child: InkWell(
            onTap: () {
              CustomMaterial.sendNotification(context, "Çok Yakında Sizlerle!");
              //Navigator.pushNamed(context, RouterConstants.myPayments);
            },
            child: const Icon(
              Icons.currency_lira,
              color: ColorConstants.infoDark,
            ),
          ),
        );
    }
  }

  String getMenteeId() {
    if (mentee != null) {
      return mentee!.getId()!;
    } else {
      return "";
    }
  }
}
