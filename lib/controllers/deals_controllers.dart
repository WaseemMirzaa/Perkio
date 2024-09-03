import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:swipe_app/services/deals_service.dart';

class DealsController extends GetxController {
  final DealsService _dealsService = DealsService();
  var promotions = <DocumentSnapshot>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;




  @override
  void onInit() {
    fetchPromotions();
    super.onInit();
  }

  Future<void> fetchPromotions() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      final fetchedPromotions = await _dealsService.fetchPromotions();
      promotions.value = fetchedPromotions;
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
