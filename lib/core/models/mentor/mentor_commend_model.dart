import 'package:guide_up/core/models/general/general_fields_model.dart';

import '../../utils/control_helper.dart';

/// [@author MrBigBear] 
class MentorComment extends GeneralFields {
  String? _id;
  String? _menteeId;
  String? _mentorId;
  int? _rate;
  String? _commend;
  bool _isAnonymous = false;

  String? getId() {
    return _id;
  }

  void setId(String id) {
    _id = id;
  }

  String? getMenteeId() {
    return _menteeId;
  }

  void setMenteeId(String menteeId) {
    _menteeId = menteeId;
  }

  String? getMentorId() {
    return _mentorId;
  }

  void setMentorId(String mentorId) {
    _mentorId = mentorId;
  }

  int? getRate() {
    return _rate;
  }

  void setRate(int rate) {
    _rate = rate;
  }

  String? getComment() {
    return _commend;
  }

  void setComment(String commend) {
    _commend = commend;
  }

  bool isAnonymous() {
    return _isAnonymous;
  }

  void setAnonymous(bool isAnonymous) {
    _isAnonymous = isAnonymous;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = toGeneralMap();
    map['id'] = getId();
    map['menteeId'] = getMenteeId();
    map['mentorId'] = getMentorId();
    map['rate'] = getRate();
    map['comment'] = getComment();
    map['isAnonymous'] = isAnonymous();
    return map;
  }

  MentorComment toClass(Map<String, dynamic> map) {
    toGeneralClass(map);

    if (ControlHelper.checkMapValue(map, 'id')) {
      setId(map['id']);
    }
    if (ControlHelper.checkMapValue(map, 'menteeId')) {
      setMenteeId(map['menteeId']);
    }
    if (ControlHelper.checkMapValue(map, 'mentorId')) {
      setMentorId(map['mentorId']);
    }
    if (ControlHelper.checkMapValue(map, 'rate')) {
      setRate(map['rate']);
    }
    if (ControlHelper.checkMapValue(map, 'comment')) {
      setComment(map['comment']);
    }
    if (ControlHelper.checkMapValue(map, 'isAnonymous')) {
      setAnonymous(map['isAnonymous']);
    }
    return this;
  }
}