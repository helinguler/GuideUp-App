import 'package:guide_up/core/models/mentor/mentor_commend_model.dart';
import 'package:guide_up/core/models/mentor/mentor_model.dart';
import 'package:guide_up/repository/mentor/mentor_comment_repository.dart';
import 'package:guide_up/repository/mentor/mentor_repository.dart';

import '../../core/models/mentor/mentee_model.dart';
import '../../repository/mentee/mentee_repository.dart';

class MenteeService {
  late MenteeRepository _menteeRepository;
  late MentorCommentRepository _mentorCommentRepository;
  late MentorRepository _mentorRepository;

  MenteeService() {
    _menteeRepository = MenteeRepository();
    _mentorCommentRepository = MentorCommentRepository();
    _mentorRepository = MentorRepository();
  }

  Future<double> getTotalPriceByUserId(String userId) async {
    List<Mentee> menteeList =
        await _menteeRepository.getMenteeListByUserId(userId);
    double totalPrice = 0.0;

    for (var mentee in menteeList) {
      if (mentee.isApproval() &&
          mentee.getPrice() != null &&
          double.parse(mentee.getPrice()!) > 0) {
        totalPrice += double.parse(mentee.getPrice()!);
      }
    }
    return totalPrice;
  }

  Future<double> getTotalPriceByMentorId(String mentorId) async {
    List<Mentee> menteeList =
        await _menteeRepository.getMenteeListByMentorId(mentorId);
    double totalPrice = 0.0;

    for (var mentee in menteeList) {
      if (mentee.isApproval() &&
          mentee.getPrice() != null &&
          double.parse(mentee.getPrice()!) > 0) {
        totalPrice += double.parse(mentee.getPrice()!);
      }
    }
    return totalPrice;
  }

  Future<void> menteeDone(Mentee mentee, MentorComment mentorComment) async {
    mentee.setApproval(true);
    _menteeRepository.update(mentee);

    _mentorCommentRepository.add(mentee.getUserId()!, mentorComment);

    List<MentorComment> commentList = await _mentorCommentRepository
        .getMentorCommentListByMentorId(mentee.getMentorId()!, 0);
    if (commentList.isNotEmpty) {
      double rate = 0.0;
      int totalRate = 0;
      for (var comment in commentList) {
        totalRate += comment.getRate()!;
      }
      rate = totalRate / commentList.length;
      Mentor? mentor =
          await _mentorRepository.get(mentee.getMentorId()!);
      if (mentor != null) {
        mentor.setRate(rate.round());
        _mentorRepository.update(mentor);
      }
    }
  }
}
