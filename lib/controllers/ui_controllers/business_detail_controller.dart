import 'package:get/get.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/deals_service.dart';
import 'package:swipe_app/services/reward_service.dart';
import 'dart:developer' as developer;

class BusinessDetailController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList<DealModel> allDeals = <DealModel>[].obs;
  RxList<DealModel> offers = <DealModel>[].obs;
  RxList<RewardModel> reward = RxList<RewardModel>([]);

  final DealService _dealService = DealService();
  final RewardService _rewardService = RewardService();

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters['businessId'] != null) {
      developer.log(
          'Fetching deals and reward for businessId: ${Get.parameters['businessId']}');
      fetchDeals(Get.parameters['businessId']!);
      fetchReward(Get.parameters['businessId']!);
    }
  }

  void selectIndex(int index) {
    developer.log('Index selected: $index');
    selectedIndex.value = index;
  }

  Future<void> fetchDeals(String businessId) async {
    try {
      developer.log('Fetching deals for businessId: $businessId');
      final deals = await _dealService.fetchDeals(businessId);
      allDeals.assignAll(deals);
      offers.assignAll(deals); // Adjust if necessary
      developer.log('Fetched ${deals.length} deals successfully');
    } catch (e) {
      developer.log('Error fetching deals: $e');
    }
  }

  Future<void> fetchReward(String businessId) async {
    try {
      developer.log('Fetching reward for businessId: $businessId');
      final rewardData = await _rewardService.fetchRewards(businessId);
      reward.value = rewardData;
      developer.log('Fetched reward successfully: $rewardData');
    } catch (e) {
      developer.log('Error fetching reward: $e');
    }
  }
}
