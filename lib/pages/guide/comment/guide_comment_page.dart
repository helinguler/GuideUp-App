import 'package:flutter/material.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/models/post/commend/commend_model.dart';
import 'package:guide_up/repository/post/comment/comment_repository.dart';

import '../../../core/dto/post/post_card_view.dart';
import '../../../core/models/users/user_detail/user_detail_model.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../ui/material/custom_material.dart';

class GuideCommentPage extends StatefulWidget {
  const GuideCommentPage({Key? key}) : super(key: key);

  @override
  State<GuideCommentPage> createState() => _GuideCommentPageState();
}

class _GuideCommentPageState extends State<GuideCommentPage> {
  TextEditingController commentController = TextEditingController();
  late PostCardView _postCardView;
  late UserDetail? _userDetail;

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
      _userDetail = detail;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _postCardView = ModalRoute.of(context)!.settings.arguments as PostCardView;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.background,
        title: const Text('Yorum Giriniz'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: CustomMaterial.backgroundBoxDecoration,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                labelText: 'Yorumunuzu Giriniz',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _postComment(context);
              },
              style: ElevatedButton.styleFrom(
                  shadowColor: ColorConstants.buttonPurple,
                  elevation: 18,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [ColorConstants.buttonPurple,ColorConstants.buttonPink]),
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Text(
                    'Yorumunu Gönder',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _postComment(BuildContext context) {
    String commentText = commentController.text;

    if (commentText.isNotEmpty &&
        _postCardView.id != null &&
        _userDetail != null) {
      Comment comment = Comment();
      comment.setPostId(_postCardView.id!);
      comment.setContent(commentText);
      comment.setUserId(_userDetail!.getUserId()!);
      CommentRepository().add(comment);

      Navigator.pop(context, comment);
    }
  }
}
