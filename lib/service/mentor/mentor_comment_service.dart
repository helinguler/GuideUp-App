import 'package:guide_up/core/dto/mentor/comment/mentor_comment_card_view.dart';
import 'package:guide_up/core/models/mentor/mentee_model.dart';
import 'package:guide_up/core/models/mentor/mentor_model.dart';
import 'package:guide_up/repository/mentee/mentee_repository.dart';
import 'package:guide_up/repository/mentor/mentor_comment_repository.dart';
import 'package:guide_up/repository/mentor/mentor_repository.dart';

import '../../core/models/mentor/mentor_commend_model.dart';

class MentorCommentService {
  late MentorCommentRepository _mentorCommentRepository;
  late MenteeRepository _menteeRepository;
  late MentorRepository _mentorRepository;

  MentorCommentService() {
    _mentorCommentRepository = MentorCommentRepository();
    _menteeRepository = MenteeRepository();
    _mentorRepository = MentorRepository();
  }

  Future<List<MentorCommentCardView>> getListByMentorId(
      String mentorId, int limit) async {
    List<MentorComment> commentList = await _mentorCommentRepository
        .getMentorCommentListByMentorId(mentorId, limit);

    return covertToCardView(commentList);
  }

  Future<List<MentorCommentCardView>> getListByMenteeId(
      String menteeId, int limit) async {
    List<MentorComment> commentList = await _mentorCommentRepository
        .getMentorCommentListByMenteeId(menteeId, limit);

    return covertToCardView(commentList);
  }

  Future<List<MentorCommentCardView>> covertToCardView(
      List<MentorComment> commentList) async {
    List<MentorCommentCardView> cardViewList = [];
    for (var comment in commentList) {
      MentorCommentCardView commentCardView = MentorCommentCardView();

      commentCardView.id = comment.getId()!;
      commentCardView.menteeId = comment.getMenteeId();
      commentCardView.mentorId = comment.getMentorId()!;
      commentCardView.comment = comment.getComment()!;
      commentCardView.rate = comment.getRate()!;
      commentCardView.isAnonymous = comment.isAnonymous();

      Mentee? mentee = await _menteeRepository.get(comment.getMenteeId()!);
      Mentor? mentor = await _mentorRepository.get(comment.getMentorId()!);
      if (comment.isAnonymous()) {
        // Anonymous comment
        commentCardView.userFullName = "Anonymous";
        commentCardView.userPhoto = null;
      } else {
        if (mentee != null) {
          commentCardView.userFullName =
              "${mentee.getName()!} ${mentee.getSurname()!}";
          commentCardView.userPhoto = mentee.getPhoto();
        }
      }
      if (mentor != null) {
        commentCardView.mentorFullName =
            "${mentor.getName()!} ${mentor.getSurname()!}";
      }

      cardViewList.add(commentCardView);
    }
    return cardViewList;
  }
}
