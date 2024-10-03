import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:swipe_app/models/receipt_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:uuid/uuid.dart';

class RewardService {
  final CollectionReference _rewardCollection =
      FirebaseFirestore.instance.collection('reward');

  Stream<List<RewardModel>> getRewardStream() {
    return _rewardCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => RewardModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  Future<List<RewardModel>> fetchRewards(String businessId) async {
    try {
      QuerySnapshot snapshot = await _rewardCollection
          .where('businessId', isEqualTo: businessId) // Filter by businessId
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<RewardModel> rewards = snapshot.docs
            .map((doc) => RewardModel.fromDocumentSnapshot(doc))
            .toList();
        return rewards;
      } else {
        log('No rewards found for businessId: $businessId');
        return [];
      }
    } catch (e) {
      log('Error fetching rewards: $e');
      return [];
    }
  }

  // Call this to get deal data from notification
  Future<RewardModel?> fetchRewardDataFromNotification(String rewardId) async {
    try {
      DocumentReference dealRef = _firestore.collection('reward').doc(rewardId);
      DocumentSnapshot dealSnapshot = await dealRef.get();

      // Check if the document exists
      if (dealSnapshot.exists) {
        return RewardModel.fromDocumentSnapshot(dealSnapshot);
      } else {
        print('Deal not found for ID: $rewardId');
        return null; // Return null if the deal doesn't exist
      }
    } catch (e) {
      print('Error fetching deal data: $e');
      return null; // Return null on error
    }
  }

  Future<void> toggleLike(String rewardId, String userId, bool isLiked) async {
    try {
      DocumentReference rewardDoc = _rewardCollection.doc(rewardId);

      if (isLiked) {
        // Add userId to the isFavourite list
        await rewardDoc.update({
          'isFavourite': FieldValue.arrayUnion([userId]),
        });
      } else {
        // Remove userId from the isFavourite list
        await rewardDoc.update({
          'isFavourite': FieldValue.arrayRemove([userId]),
        });
      }
    } catch (e) {
      log('Error updating like status: $e');
    }
  }

  Future<void> addPointsToReward(
      String rewardId, String userId, int points) async {
    try {
      DocumentReference rewardDoc = _rewardCollection.doc(rewardId);

      // Update the pointsEarned map
      await rewardDoc.update({
        'pointsEarned.$userId': FieldValue.increment(points),
      }).catchError((error) {
        log('Error updating points for user $userId in reward $rewardId: $error');
      });
    } catch (e) {
      log('Error adding points: $e');
    }
  }

  Stream<RewardModel?> getRewardByIdStream(String rewardId) {
    return _rewardCollection.doc(rewardId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return RewardModel.fromDocumentSnapshot(snapshot);
      } else {
        return null;
      }
    });
  }

  //user controller shifted here
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<RewardModel>> getFavouriteRewards() async {
    String userId = _auth.currentUser?.uid ?? '';

    // Fetch all rewards where the current user's ID is in the isFavourite list
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('reward')
        .where('isFavourite', arrayContains: userId)
        .get();

    return snapshot.docs.map((doc) => RewardModel.fromMap(doc.data())).toList();
  }

  //reward controller shifted here

  Future<UploadTask> uploadReceiptImage(
      File file, RewardModel rewardModel, String userId) async {
    final uniqueImageId = const Uuid().v4();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('receipts/${rewardModel.rewardId}/$userId/$uniqueImageId');

    // Start the file upload
    final uploadTask = storageRef.putFile(file);

    return uploadTask; // Return the UploadTask to track progress
  }

  Future<void> saveReceipt(
      RewardModel rewardModel, String userId, String downloadUrl) async {
    try {
      // Retrieve the current receipt from Firestore
      DocumentSnapshot receiptSnapshot = await _firestore
          .collection('reward')
          .doc(rewardModel.rewardId)
          .collection('receipts')
          .doc(userId)
          .get();

      ReceiptModel receipt;
      if (receiptSnapshot.exists) {
        receipt = ReceiptModel.fromMap(
            receiptSnapshot.data() as Map<String, dynamic>);
        receipt.imageUrls ??= [];
        receipt.imageUrls!.add(downloadUrl);
      } else {
        receipt = ReceiptModel(
          receiptId: userId,
          businessId: rewardModel.businessId,
          rewardId: rewardModel.rewardId,
          userId: userId,
          imageUrls: [downloadUrl],
          timestamp: DateTime.now(),
        );
      }

      // Save the updated receipt
      await _firestore
          .collection('reward')
          .doc(rewardModel.rewardId)
          .collection('receipts')
          .doc(userId)
          .set(receipt.toMap());
    } catch (e) {
      throw Exception("Error saving receipt: $e");
    }
  }

  Future<List<ReceiptModel>> fetchUserReceipts(String rewardId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    List<ReceiptModel> userReceipts = [];

    try {
      // Access the 'rewards' collection and find the document matching the passed rewardId
      DocumentSnapshot rewardDoc =
          await _firestore.collection('reward').doc(rewardId).get();

      // Check if the reward document exists
      if (rewardDoc.exists) {
        // Access the 'receipts' subcollection
        QuerySnapshot receiptsSnapshot =
            await rewardDoc.reference.collection('receipts').get();
        debugPrint(
            "Fetched receipts for reward $rewardId: ${receiptsSnapshot.docs.length}"); // Log the number of receipts per reward

        for (var receiptDoc in receiptsSnapshot.docs) {
          // Check if the document ID matches the current user UID
          if (receiptDoc.id == userId) {
            // Fetch the entire document and create ReceiptModel
            ReceiptModel receipt =
                ReceiptModel.fromMap(receiptDoc.data() as Map<String, dynamic>);
            userReceipts.add(receipt); // Add to the list of user receipts
            debugPrint(
                "Fetched receipt: ${receipt.receiptId} for user: $userId"); // Log each fetched receipt
          }
        }
      } else {
        debugPrint("No reward found with ID: $rewardId");
      }
    } catch (e) {
      debugPrint("Error fetching receipts: $e"); // Use debugPrint for errors
    }

    debugPrint(
        "Total receipts fetched for user $userId: ${userReceipts.length}"); // Log the total number of receipts
    return userReceipts; // Return the list of ReceiptModel
  }

  Future<void> updateReceiptStatus(String rewardId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    try {
      // Access the 'rewards' collection and find the document matching the passed rewardId
      DocumentSnapshot rewardDoc =
          await _firestore.collection('reward').doc(rewardId).get();

      // Check if the reward document exists
      if (rewardDoc.exists) {
        // Access the 'receipts' subcollection
        QuerySnapshot receiptsSnapshot =
            await rewardDoc.reference.collection('receipts').get();
        debugPrint(
            "Fetched receipts for reward $rewardId: ${receiptsSnapshot.docs.length}"); // Log the number of receipts per reward

        for (var receiptDoc in receiptsSnapshot.docs) {
          // Check if the document ID matches the current user UID
          if (receiptDoc.id == userId) {
            // Update the isVerified field to false
            await receiptDoc.reference.update({'isVerified': false});
            debugPrint(
                "Updated receipt: ${receiptDoc.id} to isVerified: false for user: $userId"); // Log the update
            return; // Exit after updating the first matched receipt
          }
        }
        debugPrint("No receipt found for user $userId under reward $rewardId");
      } else {
        debugPrint("No reward found with ID: $rewardId");
      }
    } catch (e) {
      debugPrint(
          "Error updating receipt status: $e"); // Use debugPrint for errors
    }
  }
}
