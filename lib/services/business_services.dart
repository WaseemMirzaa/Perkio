import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/modals/deal_modal.dart';

class BusinessServices{
  final auth = FirebaseAuth.instance;
  final CollectionReference _dealCollection =
      FirebaseFirestore.instance.collection('deals');    

  //............ Add deal
  Future addDeal({
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
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());

      if (e.message != null) print(e.message!);
    }
  }
}