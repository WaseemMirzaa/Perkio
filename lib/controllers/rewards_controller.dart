import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/reward_service.dart';

class RewardController extends GetxController {
  final RewardService _rewardService = RewardService();
  var rewardModel = Rx<RewardModel?>(null); // Holds the specific reward data

  var rewards = <RewardModel>[].obs;
  var searchedRewards = <RewardModel>[].obs; // List to hold searched results
  var isLoading = true.obs;
  var isSearching = false.obs; // Observable for search status
  var currentUserId = ''.obs; // Observable variable for the current user UID

  @override
  void onInit() {
    super.onInit();
    currentUserId.value =
        getCurrentUserId(); // Initialize with the current user UID
    listenToRewards();
  }

  String getCurrentUserId() {
    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is signed in, return UID if signed in, otherwise return an empty string or handle the case
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case where the user is not signed in
      log('No user is currently signed in.');
      return '';
    }
  }

  // Method to listen to a specific reward by rewardId
  void listenToReward(String rewardId) {
    isLoading(true);
    _rewardService.getRewardByIdStream(rewardId).listen((data) {
      rewardModel.value = data;
      isLoading(false);
    }).onError((error) {
      log('Failed to listen to reward: $error');
      isLoading(false);
    });
  }

  void listenToRewards() {
    _rewardService.getRewardStream().listen((data) {
      rewards.value = data;
      isLoading(false);
    }).onError((error) {
      log('Failed to listen to rewards: $error');
    });
  }

  // Search method to filter rewards based on search input
  void searchRewards(String query) {
    if (query.isEmpty) {
      searchedRewards.assignAll(rewards); // If query is empty, show all rewards
    } else {
      String lowerCaseQuery = query.toLowerCase();
      var filteredRewards = rewards.where((reward) {
        var rewardName = reward.rewardName?.toLowerCase() ?? '';
        var companyName = reward.companyName?.toLowerCase() ?? '';
        return rewardName.contains(lowerCaseQuery) ||
            companyName.contains(lowerCaseQuery);
      }).toList();
      searchedRewards.assignAll(filteredRewards); // Update searched rewards
    }
  }

  Future<void> toggleLike(RewardModel reward, String userId) async {
    bool isLiked = reward.isFavourite?.contains(userId) ?? false;
    await _rewardService.toggleLike(reward.rewardId!, userId, !isLiked);
    // Update the local state if needed
    listenToRewards(); // This will refresh the reward list
  }

  // Method to update the usedBy and pointsEarned fields in the reward collection
  Future<void> updateRewardUsage(String rewardId, String userId) async {
    try {
      log(userId);
      final rewardDoc =
          FirebaseFirestore.instance.collection('reward').doc(rewardId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(rewardDoc);

        if (!snapshot.exists) {
          throw Exception("Reward does not exist");
        }

        // Get current usedBy and pointsEarned data
        Map<String, dynamic> usedBy =
            snapshot.get('usedBy') as Map<String, dynamic>? ?? {};
        Map<String, dynamic> pointsEarned =
            snapshot.get('pointsEarned') as Map<String, dynamic>? ?? {};

        // Update the usage count for the user
        int currentUses = usedBy[userId] ?? 0;
        usedBy[userId] = currentUses + 1;

        // If the user exists in pointsEarned, set their points to 0
        if (pointsEarned.containsKey(userId)) {
          pointsEarned[userId] = 0;
        }

        // Update the document with the new usedBy and pointsEarned maps
        transaction.update(rewardDoc, {
          'usedBy': usedBy,
          'pointsEarned': pointsEarned,
        });
      });
    } catch (e) {
      log('Error updating reward usage and points: $e');
    }
  }
}
