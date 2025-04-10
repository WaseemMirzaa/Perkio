import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  // Subscription IDs
  static const String _monthlySubId = 'monthly_sub';
  static const String _yearlySubId = 'yearly_sub';

  // Offer IDs
  static const String _monthlyOfferId = 'monthly-offer';
  static const String _yearlyOfferId = 'yearly-offer';

  final isSubscribed = false.obs;
  final offering = Rxn<Offering>();
  final isLoading = false.obs;
  final isCancellingSubscription = false.obs;
  final currentSubscriptionType = Rxn<String>();
  final offerings = Rxn<Offerings>();
  final isInTrialPeriod = false.obs;
  final trialEndDate = Rxn<DateTime>();
  final hasTrialExpired = false.obs;

  final currentExpirationDate = Rxn<DateTime>();
  final subscriptionStatus = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    initializePurchases();
    isUserSubscribed();
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
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      // Check if user has any active entitlements
      isSubscribed.value = customerInfo.entitlements.active.isNotEmpty;

      if (isSubscribed.value) {
        // Get the active entitlement
        final activeEntitlement = customerInfo.entitlements.active.values.first;

        // Check if in trial period
        isInTrialPeriod.value =
            activeEntitlement.periodType == PeriodType.trial;

        if (isInTrialPeriod.value) {
          trialEndDate.value =
              DateTime.parse(activeEntitlement.expirationDate!);
          final now = DateTime.now();
          hasTrialExpired.value = trialEndDate.value?.isBefore(now) ?? false;

          if (!hasTrialExpired.value) {
            subscriptionStatus.value = 'Trial Period';
          }
        } else {
          // Regular subscription
          currentExpirationDate.value =
              DateTime.parse(activeEntitlement.expirationDate!);
          subscriptionStatus.value =
              activeEntitlement.identifier == _monthlySubId
                  ? 'Monthly Subscription'
                  : 'Yearly Subscription';
        }
      }
    } catch (e) {
      print('Error checking subscription status: $e');
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

  Future<void> purchaseSubscription(Package package) async {
    try {
      isLoading.value = true;

      // Check for existing subscription
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.active.isNotEmpty) {
        isSubscribed.value = true;
        await checkSubscriptionStatus();
        showWarning('You already have an active subscription');
        return;
      }

      // Purchase with trial
      final purchaseResult = await Purchases.purchasePackage(package);

      if (purchaseResult.entitlements.active.isNotEmpty) {
        isSubscribed.value = true;
        isInTrialPeriod.value = true;

        // Set trial end date
        final now = DateTime.now();
        trialEndDate.value = now.add(const Duration(days: 7));

        // Store subscription type for after trial
        currentSubscriptionType.value =
            package.packageType == PackageType.monthly ? 'monthly' : 'yearly';

        await Purchases.invalidateCustomerInfoCache();
        await checkSubscriptionStatus();

        showSuccess(
            'Free trial started! You\'ll be subscribed automatically after 7 days.');
        Get.back();
      } else {
        showWarning('Subscription process incomplete. Please try again.');
      }
    } catch (e) {
      showError('Failed to start subscription: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restorePurchases() async {
    isLoading.value = true;
    try {
      await Purchases.restorePurchases();
      await checkSubscriptionStatus();

      if (isSubscribed.value) {
        showSuccess('Purchases restored successfully!');
      } else {
        showWarning('No previous subscriptions found');
      }
    } catch (e) {
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
      final monthlyEntitlement =
          customerInfo.entitlements.active[_monthlySubId];
      final yearlyEntitlement = customerInfo.entitlements.active[_yearlySubId];

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
          final url =
              Uri.parse('https://play.google.com/store/account/subscriptions');
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

        final isStillSubscribed =
            customerInfo.entitlements.active.containsKey(_monthlySubId) ||
                customerInfo.entitlements.active.containsKey(_yearlySubId);

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
          showWarning(
              'Please check your subscription status later. Changes may take some time to reflect.');
        }
      } catch (e) {
        print('Error checking subscription status: $e');
        timer.cancel(); // Stop polling on error
        isCancellingSubscription.value = false;
        showError(
            'Error updating subscription status. Please check again later.');
      }
    });
  }

  Package? _getPackageForType(String type) {
    final packageId = type == 'monthly' ? 'monthly_sub' : 'yearly_sub';
    return offering.value?.getPackage(packageId);
  }

  Future<void> _handlePurchaseResult(CustomerInfo purchaseResult) async {
    final entitlement = purchaseResult.entitlements.active[_monthlySubId] ??
        purchaseResult.entitlements.active[_yearlySubId];
    if (entitlement != null) {
      await checkSubscriptionStatus();
      showSuccess('Subscription activated successfully!');
    }
  }

  void _resetSubscriptionData() {
    isSubscribed.value = false;
    currentSubscriptionType.value = null;
    currentExpirationDate.value = null;
    subscriptionStatus.value = null;
    isInTrialPeriod.value = false;
    trialEndDate.value = null;
    hasTrialExpired.value = false;
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
  //  Future<bool> isUserSubscribed() async {
  //   try {
  //     CustomerInfo customerInfo = await Purchases.getCustomerInfo();

  //     // Check if user has any active entitlements
  //     return customerInfo.entitlements.active.isNotEmpty;

  //   } catch (e) {
  //     print('Error checking subscription status: $e');
  //     return false;
  //   }
  // }

  Future<bool> isUserSubscribed() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      
      // Check if user has any active entitlements
      bool hasActiveSubscription = customerInfo.entitlements.active.isNotEmpty;
      
      // Update the observable value
      isSubscribed.value = hasActiveSubscription;

      // Check subscription type if user is subscribed
      if (hasActiveSubscription) {
        // Check for monthly subscription
        if (customerInfo.entitlements.active[_monthlySubId] != null) {
          currentSubscriptionType.value = 'monthly';
        }
        // Check for yearly subscription
        else if (customerInfo.entitlements.active[_yearlySubId] != null) {
          currentSubscriptionType.value = 'yearly';
        }
      } else {
        currentSubscriptionType.value = null;
      }
      
      print("is subscribed: ${isSubscribed.value}, type: ${currentSubscriptionType.value}");
      return hasActiveSubscription;
      
    } catch (e) {
      print('Error checking subscription status: $e');
      isSubscribed.value = false;
      currentSubscriptionType.value = null;
      return false;
    }
  }
}
