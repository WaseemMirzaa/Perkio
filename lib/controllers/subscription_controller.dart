import 'package:get/get.dart';
import '../services/revenue_cat_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionController extends GetxController {
  var isSubscribed = false.obs;
  var offering = Rxn<Offering>(); // Store the fetched offering
  var isLoading = false.obs;

  @override
  void onInit() {
    checkSubscription();
    loadOfferings();
    super.onInit();
  }

  Future<void> checkSubscription() async {
    isSubscribed.value = await RevenueCatService.isUserSubscribed();
  }

  Future<void> loadOfferings() async {
    isLoading.value = true;
    offering.value = await RevenueCatService.getCurrentOffering();
    isLoading.value = false;
  }

  Future<void> purchaseSubscription() async {
    if (offering.value?.annual == null) return; // Ensure offering exists

    isLoading.value = true;
    bool success = await RevenueCatService.purchaseProduct(offering.value!.annual!.storeProduct);
    if (success) {
      checkSubscription();
    }
    isLoading.value = false;
  }

  Future<void> restorePurchases() async {
    isLoading.value = true;
    await RevenueCatService.restorePurchases();
    checkSubscription();
    isLoading.value = false;
  }
}