import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY';
  // Update entitlement IDs to match PlayStore products
  static const String _monthlyEntitlementId = 'monthly_sub';
  static const String _yearlyEntitlementId = 'yearly_sub';

  final isSubscribed = false.obs;
  final offering = Rxn<Offering>();
  final isLoading = false.obs;
  final isCancellingSubscription = false.obs;
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

      // Check for either subscription type
      final monthlyEntitlement = customerInfo.entitlements.active[_monthlyEntitlementId];
      final yearlyEntitlement = customerInfo.entitlements.active[_yearlyEntitlementId];

      // Debug log
      print("Active entitlements: ${customerInfo.entitlements.active.keys}");
      print("Monthly entitlement: $monthlyEntitlement");
      print("Yearly entitlement: $yearlyEntitlement");

      isSubscribed.value = monthlyEntitlement != null || yearlyEntitlement != null;

      if (isSubscribed.value) {
        // Set subscription type
        if (monthlyEntitlement != null) {
          currentSubscriptionType.value = 'monthly';
          subscriptionStatus.value = 'Active Monthly Subscription'; // Save status for monthly
        } else if (yearlyEntitlement != null) {
          currentSubscriptionType.value = 'yearly';
          subscriptionStatus.value = 'Active Yearly Subscription'; // Save status for yearly
        }

        // Set expiration date if available
        final activeSubscription = monthlyEntitlement ?? yearlyEntitlement;
        if (activeSubscription?.expirationDate != null) {
          final expiryDate = activeSubscription!.expirationDate;
          currentExpirationDate.value = expiryDate as DateTime?;
          subscriptionStatus.value = 'Active until ${_formatDate(expiryDate as DateTime)}'; // Update expiration
        }
      } else {
        // Check if there's any active entitlement (fallback check)
        final anyActiveEntitlement = customerInfo.entitlements.active.isNotEmpty;
        if (anyActiveEntitlement) {
          // If there's any active entitlement, consider it as subscribed
          isSubscribed.value = true;
          currentSubscriptionType.value = 'yearly'; // Default to yearly if specific type unknown
          subscriptionStatus.value = 'Active Yearly Subscription'; // Fallback status
        } else {
          // Reset subscription data
          _resetSubscriptionData();
        }
      }

      print("Subscription status check - isSubscribed: ${isSubscribed.value}, type: ${currentSubscriptionType.value}");
    } catch (e) {
      print("Error checking subscription status: $e");
      showError('Failed to check subscription status: ${e.toString()}');
    }
  }

  // Future<void> checkSubscriptionStatus() async {
  //   try {
  //     final customerInfo = await Purchases.getCustomerInfo();
  //
  //     // Check for either subscription type
  //     final monthlyEntitlement = customerInfo.entitlements.active[_monthlyEntitlementId];
  //     final yearlyEntitlement = customerInfo.entitlements.active[_yearlyEntitlementId];
  //
  //     // Debug log
  //     print("Active entitlements: ${customerInfo.entitlements.active.keys}");
  //     print("Monthly entitlement: $monthlyEntitlement");
  //     print("Yearly entitlement: $yearlyEntitlement");
  //
  //     isSubscribed.value = monthlyEntitlement != null || yearlyEntitlement != null;
  //
  //     if (isSubscribed.value) {
  //       // Set subscription type
  //       currentSubscriptionType.value = monthlyEntitlement != null ? 'monthly' : 'yearly';
  //
  //       // Set subscription status message
  //       final activeSubscription = monthlyEntitlement ?? yearlyEntitlement;
  //       if (activeSubscription?.expirationDate != null) {
  //         final expiryDate = activeSubscription!.expirationDate;
  //         currentExpirationDate.value = expiryDate as DateTime?;
  //         subscriptionStatus.value = 'Active until ${_formatDate(expiryDate as DateTime)}';
  //       } else {
  //         subscriptionStatus.value = 'Active subscription';
  //       }
  //     } else {
  //       // Check if there's any active entitlement (fallback check)
  //       final anyActiveEntitlement = customerInfo.entitlements.active.isNotEmpty;
  //       if (anyActiveEntitlement) {
  //         // If there's any active entitlement, consider it as subscribed
  //         isSubscribed.value = true;
  //         currentSubscriptionType.value = 'yearly'; // Default to yearly if specific type unknown
  //         subscriptionStatus.value = 'Active subscription';
  //       } else {
  //         // Reset subscription data
  //         _resetSubscriptionData();
  //       }
  //     }
  //
  //     print("Subscription status check - isSubscribed: ${isSubscribed.value}, type: ${currentSubscriptionType.value}");
  //   } catch (e) {
  //     print("Error checking subscription status: $e");
  //     showError('Failed to check subscription status: ${e.toString()}');
  //   }
  // }

  Future<void> purchaseSubscription(Package type) async {
    try {
      // First check if user is already subscribed
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.active.containsKey(_monthlyEntitlementId) ||
          customerInfo.entitlements.active.containsKey(_yearlyEntitlementId)) {
        // User is already subscribed
        isSubscribed.value = true;
        await checkSubscriptionStatus(); // Add this to update status
        showWarning('You already have an active subscription');
        return;
      }

      isLoading.value = true;

      final package = type;
      final purchaseResult = await Purchases.purchasePackage(package);

      // Check if the purchase was successful
      if (purchaseResult.entitlements.active.containsKey(_monthlyEntitlementId) ||
          purchaseResult.entitlements.active.containsKey(_yearlyEntitlementId)) {
        isSubscribed.value = true;
        
        // Force refresh customer info cache
        await Purchases.invalidateCustomerInfoCache();
        await checkSubscriptionStatus(); // Update subscription status
        
        // Update subscription type based on package
        currentSubscriptionType.value = package.packageType == PackageType.monthly ? 'monthly' : 'yearly';
        
        // Update expiration date if available
        // if (purchaseResult.latestExpirationDate != null) {
        //   currentExpirationDate.value = purchaseResult.latestExpirationDate;
        //   subscriptionStatus.value = 'Active until ${_formatDate(purchaseResult.latestExpirationDate!)}';
        // } else {
        //   subscriptionStatus.value = 'Active subscription';
        // }

        showSuccess('Subscription activated successfully!');
        Get.back(); // Close the subscription dialog
      } else {
        showWarning('Subscription process incomplete. Please try again.');
      }

    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.productAlreadyPurchasedError) {
        showWarning('You already have an active subscription');
        isSubscribed.value = true;
        await Purchases.invalidateCustomerInfoCache();
        await checkSubscriptionStatus();
        Get.back();
      } else if (e != PurchasesErrorCode.purchaseCancelledError) {
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
    try {
      isCancellingSubscription.value = true;
      isLoading.value = true;

      // Get current customer info
      final customerInfo = await Purchases.getCustomerInfo();

      // Check which subscription is active
      final monthlyEntitlement = customerInfo.entitlements.active[_monthlyEntitlementId];
      final yearlyEntitlement = customerInfo.entitlements.active[_yearlyEntitlementId];

      if (monthlyEntitlement != null || yearlyEntitlement != null) {
        if (Platform.isIOS) {
          final url = Uri.parse('app-settings:');
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
            showWarning('Please cancel your subscription in iOS Settings');
            _startPollingSubscriptionStatus();
          } else {
            showError('Could not open Settings app');
          }
        } else if (Platform.isAndroid) {
          final url = Uri.parse(
            'https://play.google.com/store/account/subscriptions'
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
            showWarning('Please cancel your subscription in Google Play');
            _startPollingSubscriptionStatus();
          } else {
            showError('Could not open Play Store');
          }
        }
        Get.back(); // Close any open dialogs
      } else {
        showWarning('No active subscription found');
      }
    } catch (e) {
      showError('Failed to cancel subscription: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Improved polling method
  void _startPollingSubscriptionStatus() {
    // Poll every 5 seconds for 5 minutes (60 attempts)
    int attempts = 0;
    const maxAttempts = 60;
    const pollInterval = Duration(seconds: 5);

    Timer.periodic(pollInterval, (Timer timer) async {
      attempts++;

      try {
        // Force cache refresh
        await Purchases.invalidateCustomerInfoCache();
        final customerInfo = await Purchases.getCustomerInfo();

        final isStillSubscribed = customerInfo.entitlements.active.containsKey(_monthlyEntitlementId) ||
                                customerInfo.entitlements.active.containsKey(_yearlyEntitlementId);

        // Update subscription status
        isSubscribed.value = isStillSubscribed;

        if (!isStillSubscribed) {
          // Subscription was cancelled successfully
          currentSubscriptionType.value = null;
          currentExpirationDate.value = null;
          subscriptionStatus.value = 'Not subscribed';
          isCancellingSubscription.value = false;
          showSuccess('Subscription cancelled successfully');
          timer.cancel(); // Stop polling
          return;
        }

        // Stop polling after max attempts
        if (attempts >= maxAttempts) {
          timer.cancel();
          isCancellingSubscription.value = false;
          showWarning('Please check your subscription status later. Changes may take some time to reflect.');
        }
      } catch (e) {
        print('Error checking subscription status: $e');
        timer.cancel(); // Stop polling on error
        isCancellingSubscription.value = false;
        showError('Error updating subscription status. Please check again later.');
      }
    });
  }

  Package? _getPackageForType(String type) {
    final packageId = type == 'monthly' ? 'monthly_sub' : 'yearly_sub';
    return offering.value?.getPackage(packageId);
  }

  Future<void> _handlePurchaseResult(CustomerInfo purchaseResult) async {
    final entitlement = purchaseResult.entitlements.active[_monthlyEntitlementId] ??
                        purchaseResult.entitlements.active[_yearlyEntitlementId];
    if (entitlement != null) {
      await checkSubscriptionStatus();
      showSuccess('Subscription activated successfully!');
    }
  }

  void _resetSubscriptionData() {
    currentSubscriptionType.value = null;
    currentExpirationDate.value = null;
    subscriptionStatus.value = 'Not subscribed';
    isSubscribed.value = false;
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
