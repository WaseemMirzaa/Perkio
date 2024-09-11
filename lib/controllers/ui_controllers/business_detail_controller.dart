import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/deals_service.dart';
import 'package:swipe_app/services/reward_service.dart';
import 'package:swipe_app/services/user_services.dart';

class BusinessDetailController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList<DealModel> allDeals = <DealModel>[].obs;
  RxList<DealModel> offers = <DealModel>[].obs;
  RxList<RewardModel> reward = RxList<RewardModel>([]);
  final UserServices _userService = UserServices();
  final DealService _dealService = DealService();
  final RewardService _rewardService = RewardService();
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  String? currentUserId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    currentUserId = _auth.currentUser?.uid;
    if (Get.parameters['businessId'] != null) {
      fetchDeals(Get.parameters['businessId']!);
      fetchReward(Get.parameters['businessId']!);
      fetchBusinessDetails(Get.parameters['businessId']!);
    }
  }

  Future<void> fetchBusinessDetails(String businessId) async {
    userModel.value = await _userService.fetchBusinessDetails(businessId);
  }

  void selectIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> fetchDeals(String businessId) async {
    try {
      final deals = await _dealService.fetchDeals(businessId);
      allDeals.assignAll(deals);
      offers.assignAll(deals);
    } catch (e) {
      print('Error fetching deals: $e');
    }
  }

  Future<void> fetchReward(String businessId) async {
    try {
      final rewardData = await _rewardService.fetchRewards(businessId);
      reward.value = rewardData;
    } catch (e) {
      print('Error fetching rewards: $e');
    }
  }

  Future<bool> canSwipe(String dealId) async {
    String userId = _auth.currentUser?.uid ?? '';
    return await _dealService.canSwipe(dealId, userId);
  }

  Future<void> updateUsedBy(String dealId) async {
    String userId = _auth.currentUser?.uid ?? '';
    await _dealService.updateUsedBy(dealId, userId);
  }

  Future<Map<String, dynamic>> fetchDealData(String dealId) async {
    return await _dealService.fetchDealData(dealId);
  }
}
