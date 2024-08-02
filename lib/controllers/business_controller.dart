import 'package:get/get.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/modals/reward_modal.dart';
import 'package:skhickens_app/services/business_services.dart';
import 'package:skhickens_app/widgets/snackbar_widget.dart';

class BusinessController extends GetxController{
  BusinessServices businessServices;
  BusinessController(this.businessServices);

  RxBool loading = false.obs;

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ ADD DEAL
  Future<bool> addDeal(DealModel dealModel) async {
    loading.value = true;
    final response = await businessServices.addDeal(dealModel:  dealModel);
    if(response){
      showSnackBar('Success', 'Deal Added Successfully');
      loading.value = false;
    } else {
      showSnackBar('Error', 'Could Not Add Deal');
      loading.value = true;
    }
    return response;
  }

  Stream<List<DealModel>> getMyDeals(String businessId){
    return businessServices.getMyDeals(businessId);
  }

  Future<bool> deleteDeal(String id, String imagePath) async {
    return await businessServices.deleteDeal(id, imagePath);
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ ADD REWARD
  Future<void> addReward(String dealName, String receiptPrice, String details) async {
    loading.value = true;
    final response = await businessServices.addReward(dealName: dealName, receiptPrice: receiptPrice, details: details);
    if(response){
      loading.value = false;
      showSnackBar('Success', 'Reward Added Successfully');
      // Get.back();
    } else {
      showSnackBar('Error', 'Could Not Add Deal');
      loading.value = true;
    }
  }
}