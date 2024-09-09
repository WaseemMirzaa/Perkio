import 'dart:developer';

import 'package:get/get.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/reward_service.dart';

class RewardController extends GetxController {
  final RewardService _rewardService = RewardService();

  var rewards = <RewardModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    listenToRewards();
  }

  void listenToRewards() {
    _rewardService.getRewardStream().listen((data) {
      rewards.value = data;
      isLoading(false);
    }).onError((error) {
      log('Failed to listen to rewards: $error');
    });
  }

  Future<void> toggleLike(RewardModel reward, String userId) async {
    bool isLiked = reward.isFavourite?.contains(userId) ?? false;
    await _rewardService.toggleLike(reward.rewardId!, userId, !isLiked);
    // Update the local state if needed
    listenToRewards(); // This will refresh the reward list
  }
}
