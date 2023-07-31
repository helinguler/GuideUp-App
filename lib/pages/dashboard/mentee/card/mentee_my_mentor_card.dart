import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/color_constants.dart';
import '../../../../core/dto/mentor/comment/my_mentor_card.dart';
import '../../../../core/utils/user_info_helper.dart';

class MenteeMyMentorCard extends StatefulWidget {
  final MyMentorCardView myMentorCardView;

  const MenteeMyMentorCard({Key? key, required this.myMentorCardView})
      : super(key: key);

  @override
  State<MenteeMyMentorCard> createState() => _MenteeMyMentorCardState();
}

class _MenteeMyMentorCardState extends State<MenteeMyMentorCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7, // Yükseltilme düzeyi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.5),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: ListTile(
        title: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundImage: UserInfoHelper.getProfilePictureByPath(
                  widget.myMentorCardView.mentorPhoto),
              radius: 35,
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  '${widget.myMentorCardView.mentorName} ${widget.myMentorCardView.mentorSurname}',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    '${widget.myMentorCardView.categoryName}',
                    softWrap: true,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: ColorConstants.theme1Mustard,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}