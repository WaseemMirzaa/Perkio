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
  Future<bool> addDeal(DealModel dealModel) async {
    List<String> nameSearchParams = setSearchParam(dealModel.dealName!);
    dealModel.dealParams = nameSearchParams;
    print("MODEL DATA IS: ${dealModel.dealParams}");
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

  /// set search param
  // List<String> setSearchParam(String caseNumber) {
  //   List<String> caseSearchList = [];
  //   for (int i = 0; i < caseNumber.length; i++) {
  //     for (int j = i + 1; j <= caseNumber.length; j++) {
  //       caseSearchList.add(caseNumber.substring(i, j));
  //     }
  //   }
  //   return caseSearchList;
  // }

  List<String> setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];

    // Convert the entire input string to lowercase and uppercase
    String lowerCaseString = caseNumber.toLowerCase();
    String upperCaseString = caseNumber.toUpperCase();

    // Generate substrings for the original, lowercase, and uppercase strings
    for (int i = 0; i < caseNumber.length; i++) {
      for (int j = i + 1; j <= caseNumber.length; j++) {
        // Add the original substring
        caseSearchList.add(caseNumber.substring(i, j));
        // Add the lowercase version of the substring
        caseSearchList.add(lowerCaseString.substring(i, j));
        // Add the uppercase version of the substring
        caseSearchList.add(upperCaseString.substring(i, j));
      }
    }

    // Optionally, remove duplicates
    caseSearchList = caseSearchList.toSet().toList();

    return caseSearchList;
  }




  /// Deal search by name
  Future<List<DealModel>> searchDealsByName(String dealName) async {
    try {
      // Reference to the Firestore collection
      final _dealCollection = FirebaseFirestore.instance.collection('deals');

      // Query the collection where dealName matches the provided parameter
      final querySnapshot = await _dealCollection
          .where('dealName', isEqualTo: dealName)
          .get();

      // Convert the query results to a list of DealModel
      List<DealModel> deals = querySnapshot.docs.map((doc) {
        return DealModel.fromDocumentSnapshot(doc);
      }).toList();

      return deals;
    } catch (e) {
      print('Error searching for deals: $e');
      return [];
    }
  }

  /// Edit my deals
  Future<bool> editMyDeal(DealModel dealModel) async {
    try {
      await _dealCollection.doc(dealModel.dealId).update(dealModel.toMap());
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());
      if (e.message != null) print(e.message!);
      return false;
    }
  }

  /// Edit my rewards
  Future<bool> editMyRewards(RewardModel rewardModel) async {
    try {
      await _rewardCollection.doc(rewardModel.rewardId).update(rewardModel.toMap());
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

  /// Get Spacific Deals
  // Stream<List<DealModel>> getMyDeals(String businessId) {
  //   return _dealCollection
  //       .where('businessId', isEqualTo: businessId)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return DealModel.fromMap(doc.data() as Map<String, dynamic>)
  //         ..dealId = doc.id; // Optional: If you need the document ID in the DealModel
  //     }).toList();
  //   });
  // }
  Stream<List<DealModel>> getMyDeals(String uid, {String? searchQuery}) {
    Query query = FirebaseFirestore.instance
        .collection(CollectionsKey.DEALS)
        .where(DealKey.BUSINESSID, isEqualTo: uid);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.where(DealKey.DEALNAME, isGreaterThanOrEqualTo: searchQuery)
          .where(DealKey.DEALNAME, isLessThan: '${searchQuery}z'); // Adjust as needed
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DealModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  /// Get my promoted deals
  Stream<List<DealModel>> getMyPromotedDeal(String uid, {String? searchQuery}){
    Query query = FirebaseFirestore.instance.collection(CollectionsKey.DEALS).where(DealKey.BUSINESSID, isEqualTo: uid).where(DealKey.ISPROMOTIONSTART, isEqualTo: true);
    if(searchQuery != null && searchQuery.isNotEmpty){
      query = query.where(DealKey.DEALNAME, isGreaterThanOrEqualTo: searchQuery).where(DealKey.DEALNAME, isLessThan: '${searchQuery}z');
    }
    return query.snapshots().map((snapshot){
      return snapshot.docs.map((doc)=> DealModel.fromDocumentSnapshot(doc)).toList();
    });
  }

  /// Get Rewards Deals
  Stream<List<RewardModel>> getMyRewardsDeal(String businessId) {
    return _rewardCollection
        .where(RewardKey.BUSINESSID, isEqualTo: businessId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RewardModel.fromMap(doc.data() as Map<String, dynamic>)
          ..rewardId = doc.id;
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

  /// Delete rewards
  Future<bool> deleteReward(String id, String imageUrl) async {
    try {
      final imagePath = _extractPathFromUrl(imageUrl);
      print("imagePath is $imagePath");

      await _rewardCollection.doc(id).delete();
      print("Deleted");

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
  Future<bool> addReward(RewardModel rewardModel) async {
    try {
      final docRef = _rewardCollection.doc();
      final rewardId = docRef.id;
      rewardModel.rewardId = rewardId;
      await docRef.set(rewardModel.toMap());
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());
      if (e.message != null) print(e.message!);
      return false;
    }
  }
}