import 'dart:developer';

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
    currentUserId.value = getCurrentUserId(); // Initialize with the current user UID
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
        return rewardName.contains(lowerCaseQuery) || companyName.contains(lowerCaseQuery);
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
}
