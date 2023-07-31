import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guide_up/core/models/mentor/mentee_model.dart';

import '../../core/constant/firestore_collectioon_constant.dart';

class MenteeRepository {
  late final CollectionReference<Map<String, dynamic>> _menteeCollection;

  MenteeRepository() {
    _menteeCollection = FirebaseFirestore.instance
        .collection(FirestoreCollectionConstant.mentee);
  }

  Future<Mentee> add(Mentee mentee) async {
    mentee.dbCheck(mentee.getUserId()!);

    var process = await _menteeCollection.add(mentee.toMap());

    mentee.setId(process.id);
    await _menteeCollection.doc(process.id).update(mentee.toMap());

    return mentee;
  }

  Future<Mentee?> get(String id) async {
    var query = await _menteeCollection.doc(id).get();

    if (query.data() != null) {
      return Mentee().toClass(query.data()!);
    }
    return null;
  }

  Future<Mentee?> getMenteeByUserIdAndMentorId(
      String userId, String mentorId) async {
    var query = await _menteeCollection
        .where("userId", isEqualTo: userId)
        .where("mentorId", isEqualTo: mentorId)
        .where("isApproval", isEqualTo: false)
        .where("isActive", isEqualTo: true)
        .orderBy("createDate", descending: false)
        .get();

    if (query.docs.isNotEmpty) {
      return Mentee().toClass(query.docs.first.data());
    }
    return null;
  }

  Future<Mentee?> getMenteeByUserId(String userId) async {
    var query =
        await _menteeCollection.where("userId", isEqualTo: userId).get();

    if (query.docs.isNotEmpty) {
      return Mentee().toClass(query.docs.first.data());
    }
    return null;
  }

  Future<List<Mentee>> getList(int limit) async {
    List<Mentee> mentorList = [];

    QuerySnapshot<Map<String, dynamic>> query;

    if (limit > 0) {
      query = await _menteeCollection.limit(limit).get();
    } else {
      query = await _menteeCollection.get();
    }

    mentorList = convertResponseObjectToList(query.docs.iterator);

    return mentorList;
  }

  Future<List<Mentee>> getMenteeListByUserId(String userId) async {
    List<Mentee> menteeList = [];
    var query =
        await _menteeCollection.where("userId", isEqualTo: userId).get();

    if (query.docs.isNotEmpty) {
      menteeList = convertResponseObjectToList(query.docs.iterator);
    }
    return menteeList;
  }

  // Mentor Favorileri için Card Yapısında Kullanılan Fonskiyon
  Future<int> getMenteeListCountByUserId(String userId) async {
    int listCount = 0;
    var query =
        await _menteeCollection.where("userId", isEqualTo: userId).get();

    if (query.docs.isNotEmpty) {
      listCount = query.docs.length;
    }
    return listCount;
  }

  Future<List<Mentee>> getMenteeListByMentorId(String mentorId) async {
    List<Mentee> menteeList = [];
    var query =
        await _menteeCollection.where("mentorId", isEqualTo: mentorId).get();

    if (query.docs.isNotEmpty) {
      menteeList = convertResponseObjectToList(query.docs.iterator);
    }
    return menteeList;
  }

  Future<int> getMenteeListCountByMentorId(String mentorId) async {
    int listCount = 0;
    var query =
        await _menteeCollection.where("mentorId", isEqualTo: mentorId).get();

    if (query.docs.isNotEmpty) {
      listCount = query.docs.length;
    }
    return listCount;
  }

  Future update(Mentee mentee) async {
    await _menteeCollection.doc(mentee.getId()!).update(mentee.toMap());
  }

  List<Mentee> convertResponseObjectToList(
      Iterator<QueryDocumentSnapshot<Map<String, dynamic>>> it) {
    List<Mentee> returnList = [];

    while (it.moveNext()) {
      QueryDocumentSnapshot<Map<String, dynamic>> snap = it.current;
      Mentee temp = Mentee();
      temp.toClass(snap.data());
      returnList.add(temp);
    }

    return returnList;
  }
}
