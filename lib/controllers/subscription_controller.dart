import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../services/revenue_cat_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  var isSubscribed = false.obs; // Initialize as false
  var offering = Rxn<Offering>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOfferings();
    // Add listener for subscription status changes
    ever(isSubscribed, (_) => update());
  }

  Future<void> checkSubscription() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      print("Refreshed Customer Info: ${customerInfo.toJson()}");

      // Extract active subscription status
      bool hasActiveSubscription = customerInfo.entitlements.active
          .containsKey('establish_agency_starter_v2');

      // Check expiration date (only for active subscriptions)
      if (hasActiveSubscription) {
        EntitlementInfo? entitlement =
            customerInfo.entitlements.active['establish_agency_starter_v2'];

        // If the expiration date has passed, mark as unsubscribed
        if (entitlement != null && entitlement.expirationDate != null) {
          DateTime expiration = DateTime.parse(entitlement.expirationDate!);
          if (DateTime.now().isAfter(expiration)) {
            hasActiveSubscription = false;
          }
        }
      }

      print("Final Active Subscription Status: $hasActiveSubscription");
      isSubscribed.value = hasActiveSubscription;
    } catch (e) {
      print("Error checking subscription: $e");
      isSubscribed.value = false;
    }
  }

  Future<void> loadOfferings() async {
    isLoading.value = true;
    try {
      offering.value = await RevenueCatService.getCurrentOffering();
      await checkSubscription();
    } catch (e) {
      print("Error loading offerings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchaseSubscription() async {
    if (offering.value?.annual == null) return;

    isLoading.value = true;
    try {
      bool success = await RevenueCatService.purchaseProduct(
          offering.value!.annual!.storeProduct);

      await checkSubscription(); // 🔥 Ensure updated status is fetched

      if (isSubscribed.value) {
        Get.snackbar(
          "Success",
          "Subscription purchased successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Subscription status not updated. Try restoring purchases.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error during purchase: $e");
      Get.snackbar(
        "Error",
        "Purchase failed: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restorePurchases() async {
    isLoading.value = true;
    try {
      await RevenueCatService.restorePurchases();
      await checkSubscription(); // 🔥 Ensure latest data is fetched

      if (isSubscribed.value) {
        Get.snackbar(
          "Restore Successful",
          "Your subscription has been restored.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "No Active Subscription",
          "No active subscription found. Please subscribe.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error restoring purchases: $e");
      Get.snackbar(
        "Restore Failed",
        "An error occurred while restoring purchases.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelSubscription() async {
    // Inform the UI that the cancellation process has started
    isLoading.value = true;

    String url = Platform.isIOS
        ? 'https://apps.apple.com/account/subscriptions'
        : 'https://play.google.com/store/account/subscriptions';

    try {
      if (await canLaunch(url)) {
        await launch(url);
        // Optionally, show some feedback like "Cancellation in progress..."
        Get.snackbar(
          "Cancellation Request",
          "We've redirected you to the subscription management page.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );

        // 🚀 Force refresh after opening subscription page
        Future.delayed(const Duration(seconds: 5), () async {
          print("Rechecking subscription after cancellation...");
          await checkSubscription();
          // Update the UI once the subscription is checked again
        });
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("Could not launch subscription page: $e");
      Get.snackbar(
        "Error",
        "Could not open subscription management page",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Stop the loading spinner after the action
    }
  }
}
