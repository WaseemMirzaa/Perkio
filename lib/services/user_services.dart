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

  // Method to check if email exists and send a password reset email
  Future<bool> resetPasswordIfEmailExists(String email) async {
    try {
      // Query Firestore to check if any document has this email
      QuerySnapshot querySnapshot =
          await _userCollection.where('email', isEqualTo: email).limit(1).get();

      // If the email exists in the users collection
      if (querySnapshot.docs.isNotEmpty) {
        // Send a password reset email
        await authServices.sendPasswordResetEmail(email);
        return true; // Indicate success
      } else {
        return false; // Indicate email not found
      }
    } catch (e) {
      return false; // General failure
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

  //.....Get User in stream

  Stream<UserModel?> gettingUserById(String userId) {
    return _userCollection.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromDocumentSnapshot(snapshot);
      } else {
        print("User Not Found");
        return null; // Return null if user is not found
      }
    });
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
  Stream<List<DealModel>> getDeals() {
    return _dealCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map<DealModel>((doc) {
        return DealModel.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
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
      print(
          'Fetching business document for ID: $businessId'); // Print business ID

      // Fetch the main business document
      DocumentSnapshot snapshot = await _userCollection.doc(businessId).get();

      // Check if the document exists
      if (snapshot.exists) {
        print(
            'Business document found. Creating UserModel...'); // Document found

        // Create UserModel from the main document
        UserModel userModel = UserModel.fromDocumentSnapshot(snapshot);
        print(
            'UserModel created: ${userModel.toJson()}'); // Print the created UserModel

        // Fetch the subcollection 'business_details'
        print('Fetching business_details subcollection...');
        QuerySnapshot subCollectionSnapshot = await _userCollection
            .doc(businessId)
            .collection('business_details')
            .get();

        // Since we know there's only one document, we access it directly
        if (subCollectionSnapshot.docs.isNotEmpty) {
          print(
              'Subcollection document found. Fetching rating...'); // Subcollection found

          // Get the first document's data for rating
          Map<String, dynamic> businessDetailsData =
              subCollectionSnapshot.docs[0].data() as Map<String, dynamic>;
          print(
              'Business details data fetched: $businessDetailsData'); // Print the business details data

          // Extract the rating from the 'result' map
          if (businessDetailsData.containsKey('result')) {
            Map<String, dynamic> resultData =
                businessDetailsData['result'] as Map<String, dynamic>;
            double rating = resultData['rating']?.toDouble() ??
                0.0; // Safely get the rating

            // Update the UserModel's rating field
            userModel.updateRating(rating);
            print(
                'UserModel updated with rating: ${userModel.rating}'); // Print the updated rating
          } else {
            print(
                'No result data found in business_details subcollection.'); // No 'result' data
          }
        } else {
          print(
              'No documents found in business_details subcollection.'); // No subcollection data
        }

        // Return the updated UserModel
        return userModel;
      } else {
        print(
            'No business document found for ID: $businessId'); // No main document found
      }
    } catch (e) {
      print(
          'Error fetching business details: $e'); // Print error if any exception occurs
    }

    // Return null if there was an error or the document didn't exist
    print('Returning null for business ID: $businessId');
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
          if (balance == 2) {
            // If the balance is exactly 2, deduct 2 and turn off promotion
            await userDocRef.update({'balance': 0});
            print('Balance updated to 0, turning off promotion.');

            // Turn off promotion
            await _updatePromotionStatus(businessId);
          } else {
            // If the balance is greater than 2, deduct 2
            await userDocRef.update({'balance': balance - 2});
            print('Balance updated, new balance: ${balance - 2}');
          }
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
        await doc.reference.update({'isPromotionStart': false, 'views': 0});
        print('Updated isPromotionStart to false for deal: ${doc.id}');
      }
    } catch (e) {
      print('Error in _updatePromotionStatus: $e');
      rethrow;
    }
  }
}
