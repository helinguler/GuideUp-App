import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/pages/mentor/card_pages/mentor_list_card.dart';
import 'package:guide_up/service/mentor/mentor_service.dart';

import '../../../core/constant/color_constants.dart';
import '../../../core/models/users/user_detail/user_detail_model.dart';
import '../../../core/utils/secure_storage_helper.dart';

class MenteeFavouriteMentorPage extends StatefulWidget {
  const MenteeFavouriteMentorPage({Key? key}) : super(key: key);

  @override
  State<MenteeFavouriteMentorPage> createState() =>
      _MenteeFavouriteMentorPageState();
}

class _MenteeFavouriteMentorPageState extends State<MenteeFavouriteMentorPage> {
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
          'Favorilerim',
          style: GoogleFonts.nunito(
            textStyle: TextStyle(
              color: ColorConstants.textwhite,
              fontSize: 25,
            ),
          ),
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
                      style: GoogleFonts.nunito()),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final mentor = snapshot.data![index];
                    return MentorListCard(mentor: mentor);
                  },
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                );
              }
            },
            future: MentorService().getMentorFavouriteListByUserId(getUserId()),
          ),
        ),
      ),
    );
  }
}
