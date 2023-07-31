import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/pages/dashboard/mentee/card/mentee_my_mentor_card.dart';
import 'package:guide_up/service/mentor/mentor_service.dart';

import '../../../core/constant/color_constants.dart';
import '../../../core/models/users/user_detail/user_detail_model.dart';
import '../../../core/utils/secure_storage_helper.dart';

class MenteeMyMentorPage extends StatefulWidget {
  const MenteeMyMentorPage({Key? key}) : super(key: key);

  @override
  State<MenteeMyMentorPage> createState() => _MenteeMyMentorPageState();
}

class _MenteeMyMentorPageState extends State<MenteeMyMentorPage> {
  UserDetail? userDetail;

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
      setState(() {});
    }
  }

  String getUserId() {
    if (userDetail != null) {
      return userDetail!.getUserId()!;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Mentorlarım',
          style: GoogleFonts.nunito(
            textStyle: TextStyle(
            color: ColorConstants.appcolor2,
            fontSize: 25,
          ),),
        ),
        backgroundColor: ColorConstants.darkBack,
      ),
      backgroundColor: ColorConstants.darkBack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Favori mentorları şu an listeyemiyoruz.',
                  style: GoogleFonts.nunito()
                  ),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final cardView = snapshot.data![index];
                    return MenteeMyMentorCard(
                      myMentorCardView: cardView,
                    );
                  },
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                );
              }
            },
            future:
                MentorService().getMyMentorCardViewListByUserId(getUserId()),
          ),
        ),
      ),
    );
  }
}
