import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/service/user/user_detail/user_categories_service.dart';

import '../../../../core/constant/color_constants.dart';
import '../../../../core/models/mentor/mentor_model.dart';
import '../../../../core/utils/user_info_helper.dart';

class MentorListCard extends StatefulWidget {
  final Mentor mentor;

  const MentorListCard({Key? key, required this.mentor}) : super(key: key);

  @override
  State<MentorListCard> createState() => _MentorListCardState();
}

class _MentorListCardState extends State<MentorListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [ColorConstants.buttonPink, ColorConstants.buttonPurple]),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.buttonPurple.withOpacity(0.55),
            //spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Card(
        margin: EdgeInsets.all(2),
        color: ColorConstants.background,
        elevation: 0,
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, RouterConstants.mentorPreview,
                arguments: widget.mentor);
          },
          leading: CircleAvatar(
            backgroundImage: UserInfoHelper.getProfilePictureByPath(
                widget.mentor.getPhoto()),
            radius: 35,
          ),
          title: Text(
            '${widget.mentor.getName()!} ${widget.mentor.getSurname()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: widget.mentor.getRate()! * 25,
                    height: 20,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        );
                      },
                      itemCount: widget.mentor.getRate(),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: UserCategoriesService()
                    .getUserCategoriesList(widget.mentor.getUserId()!, 2),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final title = snapshot.data!.map((e) => e.getName());
                    return Text(
                      "Kategoriler: ${title.toString().replaceAll('(', '').replaceAll(')', '')}..",
                      style: GoogleFonts.nunito(
                        color: ColorConstants.textGray,
                        fontSize: 12,
                      ),
                      maxLines: 4,
                      textAlign: TextAlign.left,
                    );
                  } else {
                    return const Text("");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
