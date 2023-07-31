import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guide_up/core/constant/secure_strorage_constant.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';

import '../../../core/constant/firestore_collectioon_constant.dart';

class UserDetailRepository {
  late final CollectionReference<Map<String, dynamic>> _userDetailCollections;

  UserDetailRepository() {
    _userDetailCollections = FirebaseFirestore.instance
        .collection(FirestoreCollectionConstant.userDetail);
  }

  Future<UserDetail> add(UserDetail userDetail) async {
    userDetail.dbCheck(userDetail.getUserId()!);

    var process = await _userDetailCollections.add(userDetail.toMap());

    userDetail.setId(process.id);
    await _userDetailCollections.doc(process.id).update(userDetail.toMap());

    return userDetail;
  }

  Future<UserDetail?> get(String id) async {
    var query = await _userDetailCollections.doc(id).get();

    if (query.data() != null) {
      return UserDetail().toClass(query.data()!);
    }
    return null;
  }

  Future<UserDetail?> getUserByUserId(String userId) async {
    var query =
        await _userDetailCollections.where("userId", isEqualTo: userId).get();

    if (query.docs.isNotEmpty) {
      return UserDetail().toClass(query.docs.first.data());
    }
    return null;
  }

  Future<UserDetail?> getUserByAuthUid(String authUid) async {
    var userCollections =
        FirebaseFirestore.instance.collection(FirestoreCollectionConstant.user);

    var userQuery = await userCollections.where("id", isEqualTo: authUid).get();

    if (userQuery.docs.isNotEmpty) {
      var detailQuery = await _userDetailCollections
          .where("userId", isEqualTo: userQuery.docs.first.id)
          .get();

      if (detailQuery.docs.isNotEmpty) {
        return UserDetail().toClass(detailQuery.docs.first.data());
      }
    }
    return null;
  }

  Future<UserDetail> update(UserDetail userDetail) async {
    await _userDetailCollections
        .doc(userDetail.getId()!)
        .update(userDetail.toMap());
    var newUserDetail = await get(userDetail.getId()!);
    if (newUserDetail != null) {
      const FlutterSecureStorage().write(
          key: SecureStrogeConstants.USER_DETAIL_KEY,
          value: newUserDetail.toJson());
      return newUserDetail;
    }
    return userDetail;
  }
}
