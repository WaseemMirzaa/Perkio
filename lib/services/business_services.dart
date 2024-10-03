import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/push_notification_service.dart';

class BusinessServices {
  final auth = FirebaseAuth.instance;
  final CollectionReference _dealCollection =
      FirebaseFirestore.instance.collection(CollectionsKey.DEALS);
  final CollectionReference _rewardCollection =
      FirebaseFirestore.instance.collection(CollectionsKey.REWARDS);
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(CollectionsKey.USERS);

  final db = FirebaseFirestore.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  //............ Add Deal
  Future<bool> addDeal(DealModel dealModel) async {
    List<String> nameSearchParams =
        setSearchParam(dealModel.dealName!.toLowerCase());
    dealModel.dealParams = nameSearchParams;
    print("MODEL DATA IS: ${dealModel.dealParams}");
    try {
      final docRef = _dealCollection.doc();
      final dealId = docRef.id;
      dealModel.dealId = dealId;
      await docRef.set(dealModel.toMap());

      // Send notification to all users after the deal is added
      await sendNotificationToAllUsers(dealModel);

      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());
      if (e.message != null) print(e.message!);
      return false;
    }
  }

  Future<void> sendNotificationToAllUsers(DealModel dealModel) async {
    log('Fetching user documents to collect FCM tokens...');

    // Fetch all user documents
    final snapshot = await _usersCollection.get();
    List<String> allTokens = [];

    // Loop through each user document and collect their FCM tokens
    for (var doc in snapshot.docs) {
      List<dynamic> tokens =
          (doc.data() as Map<String, dynamic>)['fcmTokens'] ?? [];

      // Log the collected tokens for each user
      log('User: ${doc.id}, FCM Tokens: $tokens');

      allTokens.addAll(tokens.map((token) => token.toString()).toList());
    }

    log('Collected FCM tokens: $allTokens');

    // Now send notification to all collected tokens
    if (allTokens.isNotEmpty) {
      log('Sending notification for new deal: ${dealModel.dealName} to ${allTokens.length} users.');

      try {
        await sendNotification(
          token: allTokens,
          notificationType: 'newDeal',
          title: 'New Deal Added!',
          msg: 'Check out our latest deal: ${dealModel.dealName}',
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

  /// set search param
  List<String> setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    for (int i = 0; i < caseNumber.length; i++) {
      for (int j = i + 1; j <= caseNumber.length; j++) {
        caseSearchList.add(caseNumber.substring(i, j));
      }
    }
    return caseSearchList;
  }

  /// Deal search by name
  Future<List<DealModel>> searchDealsByName(String dealName) async {
    try {
      // Reference to the Firestore collection
      final dealCollection = FirebaseFirestore.instance.collection('deals');

      // Query the collection where dealName matches the provided parameter
      final querySnapshot =
          await dealCollection.where('dealName', isEqualTo: dealName).get();

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
      await _rewardCollection
          .doc(rewardModel.rewardId)
          .update(rewardModel.toMap());
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
          ..dealId =
              doc.id; // Optional: If you need the document ID in the DealModel
      }).toList();
    });
  }

  /// Get Spacific Deals
  Stream<List<DealModel>> getMyDeals(String uid, {String? searchQuery}) {
    Query query = FirebaseFirestore.instance
        .collection(CollectionsKey.DEALS)
        .where(DealKey.BUSINESSID, isEqualTo: uid);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      String lowercaseQuery = searchQuery.toLowerCase();

      query = query
          .where(DealKey.DEALNAME, isGreaterThanOrEqualTo: lowercaseQuery)
          .where(DealKey.DEALNAME,
              isLessThanOrEqualTo: '$lowercaseQuery\uf8ff');
    }

    return query.snapshots().map((snapshot) {
      print(snapshot.docs.length);
      return snapshot.docs
          .map((doc) => DealModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  /// Get my promoted deals
  Stream<List<DealModel>> getMyPromotedDeal(String uid, {String? searchQuery}) {
    Query query = FirebaseFirestore.instance
        .collection(CollectionsKey.DEALS)
        .where(DealKey.BUSINESSID, isEqualTo: uid)
        .where(DealKey.ISPROMOTIONSTART, isEqualTo: true);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
          .where(DealKey.DEALNAME, isGreaterThanOrEqualTo: searchQuery)
          .where(DealKey.DEALNAME, isLessThan: '${searchQuery}z');
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DealModel.fromDocumentSnapshot(doc))
          .toList();
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

  ///
  Stream<int?> getPPS() {
    try {
      final documentRef = db.collection(CollectionsKey.SETTINGS).doc('pps');
      return documentRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          var ppsValue = snapshot.data()?['pps'];
          return ppsValue as int?;
        } else {
          return null;
        }
      });
    } catch (e) {
      return Stream.value(null);
    }
  }

  /// Get amount per click
  Stream<int?> getAmountPerClick() {
    try {
      final documentRef = db.collection(CollectionsKey.SETTINGS).doc('apc');
      return documentRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          var ppsValue = snapshot.data()?['apc'];
          return ppsValue as int?;
        } else {
          return null;
        }
      });
    } catch (e) {
      return Stream.value(null);
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
