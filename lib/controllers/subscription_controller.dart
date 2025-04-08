import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY';
  static const String _entitlementId = 'premium';

  final isSubscribed = false.obs;
  final offering = Rxn<Offering>();
  final isLoading = false.obs;
  final currentSubscriptionType = Rxn<String>();
  final offerings = Rxn<Offerings>();

  final currentExpirationDate = Rxn<DateTime>();
  final subscriptionStatus = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    initializePurchases();
  }

  Future<void> initializePurchases() async {
    isLoading.value = true;

    try {
      await Purchases.setDebugLogsEnabled(true);
      String apiKey = Platform.isAndroid
          ? 'goog_oyVwBiMHcJMhYfurnlCsjLQDxSv'
          : 'appl_TORGRcXEczpcEfaUjrNEdUxKeqO';

      await Purchases.configure(PurchasesConfiguration(apiKey));
      await loadOfferings();
      await checkSubscriptionStatus();
    } catch (e) {
      showError('Failed to initialize purchases: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();

      offering.value = offerings.getOffering('monthly_sub');
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // currentSubscriptionType.value = offerings.current.('monthly_sub').getPackage('\$rc_annual').
      this.offerings.value = offerings;

      // print(offerings.getOffering('identifier'))

      if (offering.value == null) {
        showWarning('No subscription offerings available');
      }
    } catch (e) {
      showError('Failed to load offerings: ${e.toString()}');
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.active[_entitlementId];

      isSubscribed.value = entitlement != null;

      if (isSubscribed.value && entitlement != null) {
        // Parse expiration date
        if (entitlement.expirationDate != null) {
          currentExpirationDate.value = DateTime.parse(entitlement.expirationDate!);
        }

        // Determine subscription type
        final productId = entitlement.productIdentifier.toLowerCase();
        currentSubscriptionType.value = productId.contains('annual') ? 'yearly' : 'monthly';

        // Set subscription status
        subscriptionStatus.value = 'Active${currentExpirationDate.value != null ? " until ${_formatDate(currentExpirationDate.value!)}" : ""}';
      } else {
        _resetSubscriptionData();
      }
    } catch (e) {
      showError('Failed to check subscription status: ${e.toString()}');
    }
  }

  Future<void> purchaseSubscription(Package type) async {
    if (isSubscribed.value) {
      showWarning('You already have an active subscription');
      return;
    }

    isLoading.value = true;

    try {
      final package = type;

      if (package == null) {
        showError('Selected subscription package not available');
        return;
      }

      final purchaseResult = await Purchases.purchasePackage(package);
      await _handlePurchaseResult(purchaseResult);
    } on PurchasesErrorCode catch (e) {

      if (e != PurchasesErrorCode.purchaseCancelledError) {
        showError('Purchase failed: ${e.toString()}');
      }
    } catch (e) {
      showError('Failed to process purchase: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restorePurchases() async {
    isLoading.value = true;

    try {
      final customerInfo = await Purchases.restorePurchases();
      await checkSubscriptionStatus();

      if (isSubscribed.value) {
        showSuccess('Purchases restored successfully!');
      } else {
        showWarning('No previous subscriptions found');
      }
    } catch (e) {
      print("type ois ;===========ss${e.toString()}");

      showError('Failed to restore purchases: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelSubscription() async {
    if (GetPlatform.isIOS) {
      final url = Uri.parse('https://apps.apple.com/account/subscriptions');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else if (GetPlatform.isAndroid) {
      final url = Uri.parse('https://play.google.com/store/account/subscriptions');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  Package? _getPackageForType(String type) {
    final packageId = type == 'monthly' ? 'monthly_sub' : 'yearly_sub';
    return offering.value?.getPackage(packageId);
  }

  Future<void> _handlePurchaseResult(CustomerInfo purchaseResult) async {
    final entitlement = purchaseResult.entitlements.active[_entitlementId];
    if (entitlement != null) {
      await checkSubscriptionStatus();
      showSuccess('Subscription activated successfully!');
    }
  }

  void _resetSubscriptionData() {
    currentSubscriptionType.value = null;
    currentExpirationDate.value = null;
    subscriptionStatus.value = 'Not subscribed';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void showSuccess(String message) {
    Get.snackbar('Success', message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  void showError(String message) {
    Get.snackbar('Error', message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  void showWarning(String message) {
    Get.snackbar('Notice', message,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }
}
