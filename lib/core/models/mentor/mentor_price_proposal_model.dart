import 'package:guide_up/core/models/general/general_fields_model.dart';

import '../../utils/control_helper.dart';

/// [@author MrBigBear]
class MentorPriceProposal extends GeneralFields {
  String? _id;
  String? _mentorId;
  String? _userId;
  String? _priceProposal;
  String? _categoryId;
  bool _isApproval = false;
  bool _isPayment = false;
  bool _isTransferToMentor = false;

  String? getId() {
    return _id;
  }

  void setId(String id) {
    _id = id;
  }

  String? getMentorId() {
    return _mentorId;
  }

  void setMentorId(String mentorId) {
    _mentorId = mentorId;
  }

  String? getUserId() {
    return _userId;
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  String? getPriceProposal() {
    return _priceProposal;
  }

  void setPriceProposal(String priceProposal) {
    _priceProposal = priceProposal;
  }

  String? getCategoryId() {
    return _categoryId;
  }

  void setCategoryId(String categoryId) {
    _categoryId = categoryId;
  }

  bool isApproval() {
    return _isApproval;
  }

  void setApproval(bool isApproval) {
    _isApproval = isApproval;
  }

  bool isPayment() {
    return _isPayment;
  }

  void setPayment(bool isPayment) {
    _isPayment = isPayment;
  }

  bool isTransferToMentor() {
    return _isTransferToMentor;
  }

  void setTransferToMentor(bool isTransferToMentor) {
    _isTransferToMentor = isTransferToMentor;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = toGeneralMap();
    map['id'] = getId();
    map['userId'] = getUserId();
    map['mentorId'] = getMentorId();
    map['priceProposal'] = getPriceProposal();
    map['categoryId'] = getCategoryId();
    map['isApproval'] = isApproval();
    map['isPayment'] = isPayment();
    map['isTransferToMentor'] = isTransferToMentor();
    return map;
  }

  MentorPriceProposal toClass(Map<String, dynamic> map) {
    toGeneralClass(map);

    if (ControlHelper.checkMapValue(map, 'id')) {
      setId(map['id']);
    }
    if (ControlHelper.checkMapValue(map, 'userId')) {
      setUserId(map['userId']);
    }
    if (ControlHelper.checkMapValue(map, 'mentorId')) {
      setMentorId(map['mentorId']);
    }
    if (ControlHelper.checkMapValue(map, 'priceProposal')) {
      setPriceProposal(map['priceProposal']);
    }
    if (ControlHelper.checkMapValue(map, 'categoryId')) {
      setCategoryId(map['categoryId']);
    }
    if (ControlHelper.checkMapValue(map, 'isApproval')) {
      setApproval(map['isApproval']);
    }
    if (ControlHelper.checkMapValue(map, 'isPayment')) {
      setPayment(map['isPayment']);
    }
    if (ControlHelper.checkMapValue(map, 'isTransferToMentor')) {
      setTransferToMentor(map['isTransferToMentor']);
    }
    return this;
  }
}
