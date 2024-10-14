import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/controllers/user_controller.dart';

class FavouritesScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList<DealModel> favouriteDeals = <DealModel>[].obs;
  RxList<RewardModel> favouriteRewards = <RewardModel>[].obs;

  final UserController userController = Get.find<UserController>();
  var currentUserId = ''.obs; // Observable variable for the current user UID
  RxMap<String, bool> favoriteCache =
      <String, bool>{}.obs; // Cache for favorite status

  @override
  void onInit() {
    super.onInit();
    currentUserId.value =
        getCurrentUserId(); // Initialize with the current user UID
    loadFavourites();
    Get.find<RewardController>();
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void selectIndex(int index) {
    selectedIndex.value = index;
    loadFavourites(); // Reload data when index changes
  }

  Future<void> loadFavourites() async {
    if (selectedIndex.value == 0) {
      favouriteDeals.value = await userController.getFavouriteDeals();
      // Update favorite cache
      favoriteCache.clear();
      for (var deal in favouriteDeals) {
        favoriteCache[deal.dealId!] =
            true; // Ensure cache is populated correctly
      }
    } else {
      favouriteRewards.value = await userController.fetchFavouriteRewards();
      // Update favorite cache
      favoriteCache.clear();
      for (var reward in favouriteRewards) {
        favoriteCache[reward.rewardId!] =
            true; // Ensure cache is populated correctly
      }
    }
  }
}
