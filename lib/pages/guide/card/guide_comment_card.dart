import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/dto/post/comment/post_commet_card_view.dart';
import 'package:guide_up/service/post/comment/comment_like_service.dart';
import 'package:guide_up/service/post/comment/comment_service.dart';

import '../../../core/constant/color_constants.dart';
import '../../../core/utils/user_info_helper.dart';

class GuideCommentCard extends StatefulWidget {
  final PostCommentCardView commentCardView;
  final String userId;

  const GuideCommentCard(
      {Key? key, required this.commentCardView, required this.userId})
      : super(key: key);

  @override
  State<GuideCommentCard> createState() => _GuideCommentCardState();
}

class _GuideCommentCardState extends State<GuideCommentCard> {
  bool isDelete = false;

  @override
  Widget build(BuildContext context) {
    {
      return Visibility(
        visible: !isDelete,
        child: Card(
          color: ColorConstants.background,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.commentCardView.userFullName ?? "",
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.textwhite,
                    ),
                  ),
                ),
                subtitle: Text(
                  widget.commentCardView.content ?? "",
                  maxLines: 4,
                  softWrap: true,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 11,
                      color: ColorConstants.textwhite,
                    ),
                  ),
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: UserInfoHelper.getProfilePictureByPath(
                      widget.commentCardView.userPhoto),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //FOTOĞRAF İLE GENİŞLİK EŞİTLEMEK İÇİN WİDGET
                    Text(""),
                    Text(""),
                    //BEĞEN BUTONU
                    GestureDetector(
                      onTap: () {
                        if (widget.userId.isNotEmpty) {
                          if (!widget.commentCardView.isLikeUser) {
                            CommentLikeService()
                                .add(widget.userId, widget.commentCardView.id!)
                                .then((value) {
                              if (value.getId() != null) {
                                widget.commentCardView.isLikeUser = true;
                                widget.commentCardView.likeId = value.getId()!;
                                widget.commentCardView.likeCount += 1;
                                setState(() {});
                              }
                            });
                          } else {
                            CommentLikeService()
                                .deleteById(widget.commentCardView.likeId!)
                                .then((value) {
                              widget.commentCardView.isLikeUser = false;
                              widget.commentCardView.likeId = null;
                              widget.commentCardView.likeCount -= 1;
                              setState(() {});
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: ColorConstants.buttonPurple,
                              content: Text(
                                'Üye olmayan kullanıcı beğenme yapamaz.Lütfen Giriş yapınız :)',
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.textwhite,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            maxRadius: 20,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              widget.commentCardView.isLikeUser
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.commentCardView.isLikeUser
                                  ? ColorConstants.buttonPink
                                  : ColorConstants.textwhite,
                            ),
                          ),
                          Text(
                            "${widget.commentCardView.likeCount}",
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.textwhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SİL BUTONU
                    Visibility(
                      visible: widget.commentCardView.userId! == widget.userId,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.userId.isNotEmpty) {
                            CommentService()
                                .deleteById(widget.commentCardView.id!);
                            isDelete = true;
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: ColorConstants.buttonPurple,
                                content: Text(
                                  'Üye olmayan kullanıcı beğenme yapamaz.Lütfen Giriş yapınız :)',
                                  style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.textwhite,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: const CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.delete,
                            color: ColorConstants.itemWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
