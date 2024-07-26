import 'package:get/get.dart';
import 'package:skhickens_app/services/business_services.dart';
import 'package:skhickens_app/widgets/snackbar_widget.dart';

class BusinessController extends GetxController{
  BusinessServices businessServices;
  BusinessController(this.businessServices);

  RxBool loading = false.obs;

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ ADD DEAL
  Future<void> addDeal(String dealName, String dealPrice, String uses) async {
    loading.value = true;
    final response = await businessServices.addDeal(dealName: dealName, dealPrice: dealPrice, uses: uses);
    if(response){
      snackBar('Success', 'Deal Added Successfully');
      loading.value = false;
      Get.back();
    } else {
      snackBar('Error', 'Could Not Add Deal');
      loading.value = true;
    }
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ ADD REWARD
  Future<void> addReward(String dealName, String receiptPrice, String details) async {
    loading.value = true;
    final response = await businessServices.addReward(dealName: dealName, receiptPrice: receiptPrice, details: details);
    if(response){
      snackBar('Success', 'Reward Added Successfully');
      loading.value = false;
      Get.back();
    } else {
      snackBar('Error', 'Could Not Add Deal');
      loading.value = true;
    }
  }
}