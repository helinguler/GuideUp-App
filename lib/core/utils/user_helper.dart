import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guide_up/core/constant/secure_strorage_constant.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/core/utils/secure_storage_helper.dart';
import 'package:guide_up/repository/user/user_detail/user_detail_repository.dart';
import 'package:guide_up/service/user/user_token_service.dart';

class UserHelper {
  late FirebaseAuth auth;

  UserHelper() {
    auth = FirebaseAuth.instance;
  }

  final userCollection = FirebaseFirestore.instance.collection("users");
  var secureStorage = const FlutterSecureStorage();

  Future<User?> login(String username, String password) async {
    try {
      if (username.isNotEmpty) {
        username = username.trim();
      }
      if (password.isNotEmpty) {
        password = password.trim();
      }
      var userCredential = await auth.signInWithEmailAndPassword(
          email: username, password: password);
      debugPrint("++" + userCredential.toString());

      final user = userCredential.user;
      if (user != null) {
        UserDetail? userDetail =
            await UserDetailRepository().getUserByAuthUid(user.uid);

        if (userDetail != null) {
          UserTokenService().setToken(userDetail.getUserId()!);

          const FlutterSecureStorage().write(
              key: SecureStrogeConstants.USER_DETAIL_KEY,
              value: userDetail.toJson());
        }
      }
      return userCredential.user;
    } catch (e) {
      debugPrint("--" + e.toString());

      String errorMessage = "";

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'E-posta adresi bulunamadı.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Yanlış şifre girdiniz.';
        } else {
          errorMessage = 'Giriş yapılırken bir hata oluştu.';
        }
      } else {
        errorMessage = 'Giriş yapılırken bir hata oluştu.';
      }

      throw Exception(errorMessage);
    }
  }

  Future<String> createUser(String username, String password) async {
    try {
      var userCredential = await auth.createUserWithEmailAndPassword(
          email: username, password: password);

      debugPrint("++" + userCredential.toString());

      sendEmailVerification(userCredential.user!);
      if (userCredential.user != null) {
        return userCredential.user!.uid;
      } else {
        return '';
      }
    } catch (e) {
      debugPrint("--" + e.toString());
      return '';
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential;
  }

  void sendEmailVerification(User user) async {
    try {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        debugPrint("Kullanıcı maili onaylıdır.");
      }
    } catch (e) {
      debugPrint("--" + e.toString());
    }
  }

  Future<void> signOut() async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    if (GoogleSignIn().currentUser != null) {
      GoogleSignIn().disconnect();
      debugPrint("++ Googldan çıkış yapıldı");
    } else {
      debugPrint("-- Google hesabı ile giriş bulunamadı");
    }
    if (_auth.currentUser != null) {
      _auth.signOut();
      debugPrint("++" + "Çıkış yapıldı.");
    } else {
      debugPrint("--" + "Giriş yapılmış kullanıcı bulunamadı.");
    }
    SecureStorageHelper().getUserDetail().then((detail) async {
      if (detail != null) {
        await UserTokenService().delete(detail.getUserId()!);

        secureStorage.delete(key: SecureStrogeConstants.USER_DETAIL_KEY);
      }
    });
  }

  Future<bool> checkUser() async {
    if (auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      // Perform the necessary checks to determine if the email is registered
      // For example, you can query your database or perform a Firebase Auth check.
      // Here's an example using Firebase Auth:

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'dummy-password',
      );

      if (userCredential.user != null) {
        await userCredential.user?.delete();
        return false;
      }

      return false;
    } catch (error) {
      if (error is FirebaseAuthException &&
          error.code == 'email-already-in-use') {
        return true;
      }
      print('Error while checking if email is registered: $error');
      return false;
    }
  }
}
