import 'package:get/get.dart';
import 'package:swipe_app/models/deal_modal.dart';
import 'package:swipe_app/models/reward_modal.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart';

class BusinessController extends GetxController{
  BusinessServices businessServices;
  BusinessController(this.businessServices);

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPPS();
    getAmountPerClick();
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ ADD DEAL
  Future<bool> addDeal(DealModel dealModel) async {
    loading.value = true;
    final response = await businessServices.addDeal(dealModel);
    if(response){
      showSnackBar('Success', 'Deal Added Successfully');
      loading.value = false;
    } else {
      showSnackBar('Error', 'Could Not Add Deal');
      loading.value = true;
    }
    return response;
  }

  /// Update my deals
  Future<bool> editMyDeal(DealModel dealModel)async{
    dealModel.dealParams = businessServices.setSearchParam(dealModel.dealName!.toLowerCase());
    print("Uses are: ${dealModel.uses}");
    print("Params are: ${dealModel.dealParams}");
    return await businessServices.editMyDeal(dealModel);
  }

  /// edit rewards
  Future<bool> editMyRewards(RewardModel rewardModel)async{
    return await businessServices.editMyRewards(rewardModel);
  }

  /// Get My Deals
  Stream<List<DealModel>> getMyDeals(String uid, {String? searchQuery}) {
    return businessServices.getMyDeals(uid, searchQuery: searchQuery);
  }

  /// Get my promoted deals
  Stream<List<DealModel>> getMyPromotedDeal(String uid, {String? searchQuery}){
    return businessServices.getMyPromotedDeal(uid, searchQuery: searchQuery);
  }

    /// get my rewards deals
  Stream<List<RewardModel>> getMyRewardsDeal(String businessId) {
    return businessServices.getMyRewardsDeal(businessId);
  }

  Future<bool> deleteDeal(String id, String imagePath) async {
    return await businessServices.deleteDeal(id, imagePath);
  }

  /// Reward delete
  Future<bool> deleteReward(String id, String imageUrl) async {
    print("Controller caaleed");
    return await businessServices.deleteReward(id, imageUrl);

  }

    //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ ADD REWARD
  Future<void> addReward(RewardModel rewardModel) async {
    loading.value = true;
    final response = await businessServices.addReward(rewardModel);
    if(response){
      loading.value = false;
      showSnackBar('Success', 'Reward Added Successfully');
      // Get.back();
    } else {
      showSnackBar('Error', 'Could Not Add Deal');
      loading.value = true;
    }
  }

  var pps = Rx<int?>(null);
  /// Get PPS
  Stream<int?> getPPS(){
    businessServices.getPPS().listen((ppsValue) {
      pps.value = ppsValue;  // Update the reactive variable
    }, onError: (error) {
      print('Error fetching PPS: $error');
      pps.value = 0;  // Optionally handle error case
    });
    return businessServices.getPPS();
  }

  var apc = Rx<int?>(null);
  /// Get PPS
  Stream<int?> getAmountPerClick(){
    businessServices.getAmountPerClick().listen((ppsValue) {
      apc.value = ppsValue;  // Update the reactive variable
    }, onError: (error) {
      print('Error fetching PPS: $error');
      apc.value = 0;  // Optionally handle error case
    });
    return businessServices.getPPS();
  }
}