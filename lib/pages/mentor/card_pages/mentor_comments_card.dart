import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/dto/mentor/comment/mentor_comment_card_view.dart';
import 'package:guide_up/core/utils/user_info_helper.dart';

class MentorCommentsCard extends StatefulWidget {
  final MentorCommentCardView mentorCommentCardView;

  const MentorCommentsCard({Key? key, required this.mentorCommentCardView}) : super(key: key);

  @override
  State<MentorCommentsCard> createState() => _MentorCommentsCardState();
}

class _MentorCommentsCardState extends State<MentorCommentsCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConstants.background,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "${widget.mentorCommentCardView.userFullName}",
              maxLines: 1,
              softWrap: true,
              textAlign: TextAlign.start,
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: ColorConstants.textwhite,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        widget.mentorCommentCardView.rate ?? 0,
                            (index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Mentor : ${widget.mentorCommentCardView.mentorFullName}",
                  maxLines: 1,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: ColorConstants.textwhite,
                    ),
                  ),
                ),
                Text(
                  widget.mentorCommentCardView.comment ?? "",
                  maxLines: 4,
                  softWrap: true,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textwhite,
                    ),
                  ),
                ),
              ],

            ),

            leading: CircleAvatar(
              radius: 30,
              backgroundImage: UserInfoHelper.getProfilePictureByPath(widget.mentorCommentCardView.userPhoto),
            ),
          ),
        ],
      ),
    );
  }
}
