import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/controllers/user_controller.dart';

class MyDealScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList<DealModel> favouriteDeals = <DealModel>[].obs;
  RxList<RewardModel> favouriteRewards = <RewardModel>[].obs;
  final UserController userController = Get.find<UserController>();
  var currentUserId = ''.obs; // Observable variable for the current user UID

  @override
  void onInit() {
    super.onInit();
    loadFavourites();
    currentUserId.value =
        getCurrentUserId(); // Initialize with the current user UID
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

  void selectIndex(int index) {
    selectedIndex.value = index;
    loadFavourites(); // Reload data when index changes
  }

  Future<void> loadFavourites() async {
    if (selectedIndex.value == 0) {
      favouriteDeals.value = await userController.getDealsUsedByCurrentUser();
    } else {
      favouriteRewards.value = await userController.getRewardForCurrentUser();
    }
  }
}
