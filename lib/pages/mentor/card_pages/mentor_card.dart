import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/models/mentor/mentor_model.dart';
import 'package:guide_up/core/utils/user_info_helper.dart';

import '../../../core/constant/router_constants.dart';
import '../../../service/user/user_detail/user_categories_service.dart';

class MentorCard extends StatefulWidget {
  final Mentor mentor;

  const MentorCard({Key? key, required this.mentor}) : super(key: key);

  @override
  State<MentorCard> createState() => _MentorCardState(mentor);
}

class _MentorCardState extends State<MentorCard> {
  _MentorCardState(Mentor mentor) {
    _mentor = mentor;
  }

  late Mentor _mentor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouterConstants.mentorPreview,
            arguments: _mentor);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [ColorConstants.buttonPink, ColorConstants.buttonPurple]),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.buttonPurple.withOpacity(0.75),
              //spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
          decoration: const BoxDecoration(
            color: ColorConstants.background,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: ColorConstants.backgroundGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: 150,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: UserInfoHelper.getProfilePictureByPath(
                      _mentor.getPhoto()),
                  radius: 35,
                ),
              ),
              Text(
                '${_mentor.getName()!} ${_mentor.getSurname()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _mentor.getRate()! * 25,
                    height: 25,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 25,
                        );
                      },
                      itemCount: _mentor.getRate(),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: FutureBuilder(
                  future: UserCategoriesService()
                      .getUserCategoriesList(_mentor.getUserId()!, 2),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final title = snapshot.data!.map((e) => e.getName());
                      return Text(
                        "${title.toString().replaceAll('(', '').replaceAll(')', '')}..",
                        style: GoogleFonts.nunito(
                          color: ColorConstants.textwhite,
                          fontSize: 8,
                        ),
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const Text("");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
