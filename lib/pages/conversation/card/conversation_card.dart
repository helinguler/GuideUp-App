import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/core/dto/conversation/conversation_card_view.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';

import '../../../core/constant/color_constants.dart';
import '../../../core/utils/user_info_helper.dart';

class ConversationCard extends StatelessWidget {
  final ConversationCardView conversationCardView;
  final UserDetail userDetail;

  const ConversationCard(
      {Key? key, required this.conversationCardView, required this.userDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
         // elevation: 0,
          color: Colors.transparent,
          child: ListTile(
            tileColor: Colors.transparent,
            onTap: () {
              Navigator.pushNamed(context, RouterConstants.messagesPage,
                  arguments: conversationCardView);
            },
            title: Text(
              conversationCardView.otherParticipantFullName,
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textwhite,
                ),
              ),
            ),
            subtitle: Text(
              "${conversationCardView.lastMessageSenderName} : ${conversationCardView.lastMessage}",
              maxLines: 3,
              softWrap: true,
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  fontSize: 11,
                  color: ColorConstants.textGray,
                ),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: UserInfoHelper.getProfilePictureByPath(
                  conversationCardView.otherParticipantPhoto),
              radius: 30,
            ),
          ),
        ),
       // Divider(height: 1,color: ColorConstants.textGray.withOpacity(0.4),thickness: 0.5,)
      ],
    );
  }
}
