import 'package:get/get.dart';
import 'package:skhickens_app/services/business_services.dart';

class BusinessController extends GetxController{
  BusinessServices businessServices;
  BusinessController(this.businessServices);

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ ADD DEAL
  Future<void> addDeal(String dealName, String dealPrice, String uses) async {
    return await businessServices.addDeal(dealName: dealName, dealPrice: dealPrice, uses: uses);
  }
}