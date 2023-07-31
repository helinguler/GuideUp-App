import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/dto/mentor/comment/mentor_comment_card_view.dart';
import 'package:guide_up/core/models/mentor/mentee_model.dart';
import 'package:guide_up/pages/mentor/card_pages/mentor_comments_card.dart';
import 'package:guide_up/service/mentor/mentor_comment_service.dart';
import 'package:guide_up/ui/material/custom_material.dart';

class MenteeCommentsPage extends StatefulWidget {
  const MenteeCommentsPage({Key? key}) : super(key: key);

  @override
  State<MenteeCommentsPage> createState() => _MenteeCommentsPageState();
}

class _MenteeCommentsPageState extends State<MenteeCommentsPage> {
  late Mentee _mentee;

  @override
  Widget build(BuildContext context) {
    _mentee = ModalRoute.of(context)!.settings.arguments as Mentee;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack,
        flexibleSpace: CustomMaterial.appBarFlexibleSpace,
        centerTitle: true,
        title: Text(
          'Yorumlarım',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorConstants.textwhite,
          ),
        ),
      ),
      body: Container(
        decoration: CustomMaterial.backgroundBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: CustomMaterial.backgroundBoxDecoration,
                  child: FutureBuilder<List<MentorCommentCardView>>(
                    future: MentorCommentService()
                        .getListByMenteeId(_mentee.getId()!, 0),
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
                            final mentorCommentCardViews =
                                snapshot.data![index];
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
