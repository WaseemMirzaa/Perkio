import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/auth_services.dart';

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
  Future<bool> addUserData(UserModel userModel) async {
    try {
      if (authServices.auth.currentUser != null) {
        _userCollection
            .doc(authServices.auth.currentUser!.uid)
            .set(userModel.toMap());
      } else {
        Get.snackbar('Firebase Error', 'User not found');
      }
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Firebase Error', e.toString());

      if (e.message != null) print(e.message!);
      return false;
    }
  }

  //............ Get User
  Future<UserModel?> getUserById(String userId) async {
    final querySnapshot = await _userCollection.doc(userId).get();
    if (querySnapshot.exists) {
      final userData = querySnapshot;
      return UserModel.fromDocumentSnapshot(userData);
    } else {
      print("User Not Found");
      return null; // User not found
    }
  }

  //update the view of deal
  Future<void> updateDealViews(String dealId) async {
    try {
      DocumentReference dealRef = _dealCollection.doc(dealId);
      await dealRef.update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error updating views: $e');
      // Handle error appropriately
    }
  }

  Future<void> updateDealLikes(String dealId) async {
    try {
      DocumentReference dealRef = _dealCollection.doc(dealId);
      await dealRef.update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error updating views: $e');
      // Handle error appropriately
    }
  }

  Future<void> updateDealUnLikes(String dealId) async {
    try {
      DocumentReference dealRef = _dealCollection.doc(dealId);
      // Decrement the likes field by 1
      await dealRef.update({
        'likes': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error updating likes: $e');
      // Handle error appropriately
    }
  }

  // get user stream data
  Stream<UserModel?> getUserByStream(String userId) {
    return _userCollection.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromDocumentSnapshot(snapshot);
      } else {
        print("User Not Found");
        return null; // User not found
      }
    });
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

// Add a user's favorite deal to Firestore
  Future<void> likeDeal(String dealId) async {
    final userId = authServices.auth.currentUser!.uid;
    await _dealCollection.doc(dealId).update({
      'favourites': FieldValue.arrayUnion([userId]),
    });
  }

  // Remove a user's favorite deal from Firestore
  Future<void> unLikeDeal(String dealId) async {
    final userId = authServices.auth.currentUser!.uid;
    await _dealCollection.doc(dealId).update({
      'favourites': FieldValue.arrayRemove([userId]),
    });
  }

  // Check if a deal is a favorite for the current user
  Future<bool> isDealFavorite(String dealId) async {
    final userId = authServices.auth.currentUser!.uid;
    final dealDoc = await _dealCollection.doc(dealId).get();
    final favorites = dealDoc.get('favourites') as List<dynamic>;

    return favorites.contains(userId);
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

  // Fetch rewards based on earnedPoints map
// Fetch rewards based on earnedPoints map
  Future<List<RewardModel>> getRewardsForCurrentUser() async {
    final userId = authServices.auth.currentUser!.uid;
    final querySnapshot = await _rewardCollection.get();

    // Create a list to hold rewards for the current user
    List<RewardModel> userRewards = [];

    for (var doc in querySnapshot.docs) {
      final rewardData = doc.data() as Map<String, dynamic>;
      final earnedPoints = rewardData['pointsEarned'] as Map<String, dynamic>?;

      // Check if earnedPoints is not null and contains the userId
      if (earnedPoints != null && earnedPoints.containsKey(userId)) {
        userRewards.add(RewardModel.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>));
      }
    }

    return userRewards; // Return the list of rewards for the current user
  }

// Fetch deal based on usedBy list
  Future<List<DealModel>> getDealsUsedByCurrentUser() async {
    final userId = authServices.auth.currentUser!.uid;

    // Fetch deals where 'usedBy' is not empty (optimization step)
    final querySnapshot = await _dealCollection
        .where('usedBy', isNotEqualTo: {}) // Fetch deals where 'usedBy' exists
        .get();

    // Filter results based on whether 'usedBy' map contains the userId
    return querySnapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final usedBy = Map<String, int>.from(data['usedBy'] ?? {});
      return usedBy.containsKey(
          userId); // Only return deals where userId exists in usedBy map
    }).map<DealModel>((doc) {
      return DealModel.fromDocumentSnapshot(
          doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }

  Future<UserModel?> fetchBusinessDetails(String businessId) async {
    try {
      DocumentSnapshot snapshot = await _userCollection.doc(businessId).get();
      if (snapshot.exists) {
        return UserModel.fromDocumentSnapshot(snapshot);
      }
    } catch (e) {
      print('Error fetching business details: $e');
    }
    return null;
  }

  //deduct points from user
  Future<void> checkAndUpdateBalance(String businessId) async {
    try {
      // Accessing 'users' collection and getting document by its ID
      final userDocRef = _userCollection.doc(businessId);

      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final balance = data['balance'] ?? 0;

        print(
            'Found user with businessId (docId): $businessId, balance: $balance');

        if (balance > 0) {
          // Deduct 2 from the balance
          await userDocRef.update({'balance': balance - 2});
          print('Balance updated, new balance: ${balance - 2}');
        } else {
          // If balance <= 0, go to 'deals' collection and update 'isPromotionStart'
          await _updatePromotionStatus(businessId);
        }
      } else {
        print('No user found with businessId (docId): $businessId');
      }
    } catch (e) {
      print('Error in checkAndUpdateBalance: $e');
      rethrow;
    }
  }

  // Private helper method to update promotion status
  Future<void> _updatePromotionStatus(String businessId) async {
    try {
      // Query to find all deals with the same businessId
      final querySnapshot = await _dealCollection
          .where('businessId', isEqualTo: businessId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'isPromotionStart': false});
        print('Updated isPromotionStart to false for deal: ${doc.id}');
      }
    } catch (e) {
      print('Error in _updatePromotionStatus: $e');
      rethrow;
    }
  }
}
