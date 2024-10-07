import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/services/push_notification_service.dart';

class DealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(CollectionsKey.USERS);

  // Fetch deals based on the businessId
  Future<List<DealModel>> fetchDeals(String businessId) async {
    try {
      print('Querying Firestore for deals with business ID: $businessId');
      QuerySnapshot snapshot = await _firestore
          .collection('deals')
          .where('businessId', isEqualTo: businessId)
          .get();

      print(
          'Firestore query successful. Documents found: ${snapshot.docs.length}');
      return snapshot.docs
          .map((doc) => DealModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching deals: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchDealData(String dealId) async {
    try {
      DocumentReference dealRef = _firestore.collection('deals').doc(dealId);
      DocumentSnapshot dealSnapshot = await dealRef.get();
      return dealSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching deal data: $e');
      return {};
    }
  }

  // Call this to get deal data from notification
  Future<DealModel?> fetchDealDataFromNotification(String dealId) async {
    try {
      DocumentReference dealRef = _firestore.collection('deals').doc(dealId);
      DocumentSnapshot dealSnapshot = await dealRef.get();

      // Check if the document exists
      if (dealSnapshot.exists) {
        return DealModel.fromDocumentSnapshot(dealSnapshot);
      } else {
        print('Deal not found for ID: $dealId');
        return null; // Return null if the deal doesn't exist
      }
    } catch (e) {
      print('Error fetching deal data: $e');
      return null; // Return null on error
    }
  }

  Future<void> updateUsedBy(String dealId, String userId) async {
    try {
      // Reference to the deal document
      DocumentReference dealRef = _firestore.collection('deals').doc(dealId);
      DocumentSnapshot dealSnapshot = await dealRef.get();

      if (dealSnapshot.exists) {
        DealModel dealData = DealModel.fromDocumentSnapshot(dealSnapshot);

        // Fetch the 'usedBy' field or initialize an empty map if it doesn't exist
        Map<String, int> usedBy = Map<String, int>.from(dealData.usedBy ?? {});
        usedBy[userId] = (usedBy[userId] ?? 0) + 1;

        // Fetch the user's 'userName' from 'users' collection
        DocumentReference userRef = _firestore.collection('users').doc(userId);
        DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          String userName =
              userSnapshot['userName']; // Fetch the 'userName' field
          print('UserName for userId $userId is $userName');
          // You can use this 'userName' for logging, notification, or other purposes

          // Optionally send notification
          await sendNotificationToAllUsersForDeals(dealData, userName);
        } else {
          print('No user found for userId: $userId');
        }

        // Update the 'usedBy' field in the 'deals' collection
        await dealRef.update({
          'usedBy': usedBy,
        });
      }
    } catch (e) {
      print('Error updating usedBy field: $e');
    }
  }

  Future<void> sendNotificationToAllUsersForDeals(
      DealModel dealModel, String userName) async {
    log('Fetching user documents to collect FCM tokens...');

    // Fetch all user documents
    final snapshot = await _usersCollection.get();
    List<String> allTokens = [];

    // Loop through each user document and collect their FCM tokens
    for (var doc in snapshot.docs) {
      // Check the role of the user
      String role = (doc.data() as Map<String, dynamic>)['role'] ?? '';
      String userId = doc.id;

      if (userId == dealModel.businessId) {
        log('💥💥💥💥💥💥💥 MATCHED ');
      }

      // Log the user role
      log('User: ${doc.id}, Role: $role');

      // Collect FCM tokens only if the role is 'user'
      if (role == 'business' && userId == dealModel.businessId) {
        List<dynamic> tokens =
            (doc.data() as Map<String, dynamic>)['fcmTokens'] ?? [];

        // Log the collected tokens for each user
        log('User: ${doc.id}, FCM Tokens: $tokens');

        allTokens.addAll(tokens.map((token) => token.toString()).toList());
      }
    }

    log('💥💥💥💥💥Collected FCM tokens: $allTokens');

    // Now send notification to all collected tokens
    if (allTokens.isNotEmpty) {
      log('💥💥💥💥💥Sending notification for new deal: ${dealModel.dealName} $userName users.');

      try {
        await sendNotification(
          token: allTokens,
          notificationType: 'dealUsed',
          title: '${dealModel.dealName} deal used by $userName',
          msg: 'Check out the redeemed deal by: $userName',
          docId: dealModel.dealId!,
          isGroup: false,
          name: 'Deal Notification',
          image: dealModel.image ??
              '', // Use the deal model's image URL if available
          memberIds: [], // Adjust this if you need to specify member IDs
          uid:
              '', // You can provide the UID of the user sending the deal if applicable
        );
        log('Notification sent successfully.');
      } catch (e) {
        log('Error sending notification: $e');
      }
    } else {
      log('No FCM tokens found to send notifications.');
    }
  }

  Future<bool> canSwipe(String dealId, String userId) async {
    try {
      Map<String, dynamic> dealData = await fetchDealData(dealId);
      Map<String, int> usedBy = Map<String, int>.from(dealData['usedBy'] ?? {});
      int userCurrentUsage = usedBy[userId] ?? 0;
      int maxUses = dealData['uses'] ?? 0;
      return userCurrentUsage < maxUses;
    } catch (e) {
      print('Error checking swipe eligibility: $e');
      return false;
    }
  }
}
