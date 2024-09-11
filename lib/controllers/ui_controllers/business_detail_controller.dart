import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/models/user_model.dart';
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
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  String? currentUserId; // Store the current user's UID

  @override
  void onInit() {
    super.onInit();

    // Get the current user UID from Firebase Auth
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (Get.parameters['businessId'] != null) {
      developer.log(
          'Fetching deals and reward for businessId: ${Get.parameters['businessId']}');
      fetchDeals(Get.parameters['businessId']!);
      fetchReward(Get.parameters['businessId']!);
      fetchBusinessDetails(Get.parameters['businessId']!);
    }
  }

  Future<void> fetchBusinessDetails(String businessId) async {
    try {
      developer.log('Fetching user details for businessId: $businessId');
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(businessId)
          .get();
      if (snapshot.exists) {
        userModel.value = UserModel.fromDocumentSnapshot(snapshot);
        developer
            .log('Fetched business details successfully: ${userModel.value}');
      } else {
        developer.log('No business found for businessId: $businessId');
      }
    } catch (e) {
      developer.log('Error fetching business details: $e');
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

  //add a method to update the usedBy field
  // add all users and used deals to the firestore

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUsedBy(String dealId) async {
    String userId = _auth.currentUser?.uid ?? '';

    DocumentReference dealRef = _firestore.collection('deals').doc(dealId);

    // Get the current deal document
    DocumentSnapshot dealSnapshot = await dealRef.get();

    if (dealSnapshot.exists) {
      Map<String, dynamic> dealData =
          dealSnapshot.data() as Map<String, dynamic>;

      // Get the current 'usedBy' map or create a new one
      Map<String, int> usedBy = Map<String, int>.from(dealData['usedBy'] ?? {});

      // Increment the usage count for the current user
      usedBy[userId] = (usedBy[userId] ?? 0) + 1;

      // Update the deal document with the new 'usedBy' map
      await dealRef.update({
        'usedBy': usedBy,
      });
    }
  }
}
