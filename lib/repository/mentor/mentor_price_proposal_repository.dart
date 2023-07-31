import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guide_up/core/models/general/general_repository.dart';
import 'package:guide_up/core/models/mentor/mentor_price_proposal_model.dart';

import '../../core/constant/firestore_collectioon_constant.dart';

class MentorPriceProposalRepository
    extends GeneralRepository<MentorPriceProposal> {
  late final CollectionReference<Map<String, dynamic>>
      _mentorPriceProposalCollections;

  MentorPriceProposalRepository() {
    _mentorPriceProposalCollections = FirebaseFirestore.instance
        .collection(FirestoreCollectionConstant.mentorPriceProposal);
  }

  @override
  Future<MentorPriceProposal?> get(String id) async {
    var query = await _mentorPriceProposalCollections.doc(id).get();

    if (query.data() != null) {
      return MentorPriceProposal().toClass(query.data()!);
    }
    return null;
  }

  Future<MentorPriceProposal?> getByMentorAndUserId(String mentorId,String userId) async {
    var query = await _mentorPriceProposalCollections
        .where("userId", isEqualTo: userId)
        .where("mentorId", isEqualTo: mentorId)
        .where("isApproval", isEqualTo: false)
        .where("isActive", isEqualTo: true)
        .get();

    if (query.docs.isNotEmpty) {
      return MentorPriceProposal().toClass(query.docs.first.data());
    }
    return null;
  }
  @override
  Future<List<MentorPriceProposal>> getList(String userId, int limit) async {
    List<MentorPriceProposal> proposalList = [];

    QuerySnapshot<Map<String, dynamic>> query;

    if (limit > 0) {
      query = await _mentorPriceProposalCollections
          .where("userId", isEqualTo: userId)
          .where("isActive", isEqualTo: true)
          .limit(limit)
          .get();
    } else {
      query = await _mentorPriceProposalCollections
          .where("userId", isEqualTo: userId)
          .where("isActive", isEqualTo: true)
          .get();
    }

    if (query.docs.isNotEmpty) {
      proposalList = convertResponseObjectToList(query.docs.iterator);
    }

    return proposalList;
  }

  @override
  Future<MentorPriceProposal> add(MentorPriceProposal model) async {
    model.dbCheck(model.getUserId()!);

    var process = await _mentorPriceProposalCollections.add(model.toMap());

    model.setId(process.id);
    await _mentorPriceProposalCollections.doc(process.id).update(model.toMap());

    return model;
  }

  @override
  Future<void> delete(MentorPriceProposal model) async {
    model.setActive(false);
    await _mentorPriceProposalCollections
        .doc(model.getId()!)
        .update(model.toMap());
  }



  @override
  Future<void> update(MentorPriceProposal model) async {
    await _mentorPriceProposalCollections
        .doc(model.getId()!)
        .update(model.toMap());
  }

  Future<int> getUserCommentCountByUserId(String userId) async {
    int listCount = 0;
    var query = await _mentorPriceProposalCollections
        .where("userId", isEqualTo: userId)
        .where("isActive", isEqualTo: true)
        .get();

    if (query.docs.isNotEmpty) {
      listCount = query.docs.length;
    }
    return listCount;
  }

  List<MentorPriceProposal> convertResponseObjectToList(
      Iterator<QueryDocumentSnapshot<Map<String, dynamic>>> it) {
    List<MentorPriceProposal> returnList = [];

    while (it.moveNext()) {
      QueryDocumentSnapshot<Map<String, dynamic>> snap = it.current;
      MentorPriceProposal temp = MentorPriceProposal();
      temp.toClass(snap.data());
      returnList.add(temp);
    }

    return returnList;
  }
}
