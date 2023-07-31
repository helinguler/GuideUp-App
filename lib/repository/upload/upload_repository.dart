import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:guide_up/core/constant/firestore_collectioon_constant.dart';

class UploadRepository {

  Future<String> addProfilePictureByUserId(
      String filePath, String userId) async {

    String url="";
    var profileRef = FirebaseStorage.instance
        .ref(FirestoreCollectionConstant.uploadProfilePicturesPath + userId);

    var putFile=await profileRef.putFile(File(filePath));

    if(putFile.state==TaskState.success){
      return await profileRef.getDownloadURL();
    }

    return url;
  }

  Future<String> addPostPictureByUserId(
      String filePath, String postId) async {
    String url="";

    var profileRef = FirebaseStorage.instance
        .ref(FirestoreCollectionConstant.uploadPostPicturesPath + postId);

    var putFile=await profileRef.putFile(File(filePath));

    if(putFile.state==TaskState.success){
      return await profileRef.getDownloadURL();
    }

    return url;
  }
}
