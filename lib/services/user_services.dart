import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/modals/reward_modal.dart';
import 'package:skhickens_app/modals/user_modal.dart';
import 'package:skhickens_app/services/auth_services.dart';

class UserServices {
  AuthServices authServices = AuthServices();
  final db = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _dealCollection =
      FirebaseFirestore.instance.collection('deals');    
  final CollectionReference _rewardCollection =
      FirebaseFirestore.instance.collection('reward');      

  //............ Add User
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

  //............ Update User
  Future<bool> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      DocumentReference userRef = _userCollection.doc(userId);

      await userRef.update(updatedData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //............ Get User
  Future<UserModel?> getUserById(String userId) async {
    final querySnapshot =
        await _userCollection.doc(userId).get();
    if (querySnapshot.exists) {
      final userData = querySnapshot;
      return UserModel.fromDocumentSnapshot(userData);
    } else {
      print("User Not Found");
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

  
  //............ Get Deals
  Future<List<DealModel>> getDeals() async {
    final querySnapshot = await _dealCollection.get();
    return querySnapshot.docs.map<DealModel>((doc) {
      return DealModel.fromDocumentSnapshot(
          doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }

  //............ Get Rewards
  Future<List<RewardModel>> getRewards() async {
    final querySnapshot = await _rewardCollection.get();
    return querySnapshot.docs.map<RewardModel>((doc) {
      return RewardModel.fromDocumentSnapshot(
          doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }

  //............ Like Deal
  Future<void> likeDeal(String dealId) async {
    await _dealCollection.doc(dealId).update({
    DealKey.FAVOURITES: FieldValue.arrayUnion([authServices.auth.currentUser!.uid])
    });
  }

  //............ Unlike Deal
  Future<void> unLikeDeal(String dealId) async {
    await _dealCollection.doc(dealId).update({
    DealKey.FAVOURITES: FieldValue.arrayRemove([authServices.auth.currentUser!.uid])
    });
  }

  //............ Get Favourite Deals
  Future<List<DealModel>> getFavouriteDeals(String userId) async {
  final querySnapshot = await _dealCollection
      .where(DealKey.FAVOURITES, arrayContains: userId)
      .get();
    return querySnapshot.docs.map<DealModel>((doc) {
      return DealModel.fromDocumentSnapshot(
        doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }
}