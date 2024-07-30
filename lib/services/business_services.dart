import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/modals/reward_modal.dart';

class BusinessServices{
  final auth = FirebaseAuth.instance;
  final CollectionReference _dealCollection =
      FirebaseFirestore.instance.collection('deals');    
  final CollectionReference _rewardCollection =
      FirebaseFirestore.instance.collection('reward');  

  //............ Add Deal
  Future<bool> addDeal({
    required String dealName,
    required String dealPrice,
    required String uses,
    BuildContext? context,
  }) async {
    try {
      
    final docRef = _dealCollection.doc();
    final dealId = docRef.id;

    DealModel userModel = DealModel(
      businessId: auth.currentUser!.uid,
      dealId: dealId,
      dealName: dealName,
      dealPrice: dealPrice,
      uses: uses,
    );

    await docRef.set(userModel.toMap());
    return true;
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());
      if (e.message != null) print(e.message!);
      return false;
    }
  }

  //............ Add Reward
  Future<bool> addReward({
    required String dealName,
    required String receiptPrice,
    required String details,
    BuildContext? context,
  }) async {
    try {
      
    final docRef = _rewardCollection.doc();
    final rewardId = docRef.id;

    RewardModel userModel = RewardModel(
      businessId: auth.currentUser!.uid,
      rewardId: rewardId,
      dealName: dealName,
      receiptPrice: receiptPrice,
      rewardDetails: details,
    );

    await docRef.set(userModel.toMap());
    return true;
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());
      if (e.message != null) print(e.message!);
      return false;
    }
  }
}