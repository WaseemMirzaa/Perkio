import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skhickens_app/modals/user_modal.dart';
import 'package:skhickens_app/services/auth_services.dart';

class UserServices {
  AuthServices authServices = AuthServices();
  final db = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  //............ add user
  Future addUserData({
    required String fullName,
    required String email,
    required String phone,
    required bool isUser,
    BuildContext? context,
  }) async {
    try {
      if (authServices.auth.currentUser != null) {
        UserModel userModel = UserModel(
          email: email,
          userId: authServices.auth.currentUser!.uid,
          userName: fullName,
          phoneNo: phone,
          isUser: isUser,
        );
        _userCollection
            .doc(authServices.auth.currentUser!.uid)
            .set(userModel.toMap());
      } else {
        Get.snackbar('Firebase Error', 'User not found');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());

      if (e.message != null) print(e.message!);
    }
  }

  //............ Get user
  Future<UserModel?> getUserById(String userId) async {
    final querySnapshot =
        await _userCollection.where('userId', isEqualTo: userId).get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first;
      return UserModel.fromDocumentSnapshot(userData);
    } else {
      return null; // User not found
    }
  }

  //............ Get ID from Pref
  Future<String?> getCurrentUserIdFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  //............ Get Role from Pref
  Future<bool?> getIsUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isUser');
  }
}