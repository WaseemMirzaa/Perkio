import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/modals/reward_modal.dart';

class BusinessServices{
  final auth = FirebaseAuth.instance;
  final CollectionReference _dealCollection =
      FirebaseFirestore.instance.collection(CollectionsKey.DEALS);
  final CollectionReference _rewardCollection =
      FirebaseFirestore.instance.collection(CollectionsKey.REWARDS);

  final FirebaseStorage _storage = FirebaseStorage.instance;

  //............ Add Deal
  Future<bool> addDeal({
   required DealModel dealModel
  }) async {
    try {
    final docRef = _dealCollection.doc();
    final dealId = docRef.id;
    dealModel.dealId = dealId;
    await docRef.set(dealModel.toMap());
    return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());
      if (e.message != null) print(e.message!);
      return false;
    }
  }

  /// Get all deals
  Stream<List<DealModel>> getDealsStream() {
    return _dealCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DealModel.fromMap(doc.data() as Map<String, dynamic>)
          ..dealId = doc.id; // Optional: If you need the document ID in the DealModel
      }).toList();
    });
  }

  /// Get spacific Deals
  Stream<List<DealModel>> getMyDeals(String businessId) {
    return _dealCollection
        .where('businessId', isEqualTo: businessId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DealModel.fromMap(doc.data() as Map<String, dynamic>)
          ..dealId = doc.id; // Optional: If you need the document ID in the DealModel
      }).toList();
    });
  }

  /// Delete deals
  Future<bool> deleteDeal(String id, String imageUrl) async {
    try {
      // Extract path from the URL
      final imagePath = _extractPathFromUrl(imageUrl);
      print("imagePath is $imagePath");

      await _dealCollection.doc(id).delete();

      if (imagePath.isNotEmpty) {
        final imageRef = _storage.ref().child(imagePath);
        await imageRef.delete();
      }

      return true;
    } catch (e) {
      log('Error deleting deal: $e');
      return false;
    }
  }

  String _extractPathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Extract the path from the URI and decode it
      final path = uri.pathSegments.join('/');

      // Remove the leading '/' and return the path
      return path.startsWith('/') ? path.substring(1) : path;
    } catch (e) {
      log('Error extracting path from URL: $e');
      return '';
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