import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static Future<void> init() async {
    await Purchases.setDebugLogsEnabled(true);

    String apiKey = Platform.isAndroid
        ? 'goog_SFVBBIuzwEmVLXfudbSBzVMfHGh'
        : 'appl_rlskQNVQHfwDPQbaFJCDVfPEHlM';

    await Purchases.configure(PurchasesConfiguration(apiKey));
  }

  static Future<Offering?> getCurrentOffering() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      print("Error fetching offering: $e");
      rethrow; // Rethrow to handle in controller
    }
  }



  static Future<void> restorePurchases() async {
    try {
      await Purchases.restorePurchases();
    } catch (e) {
      print("Restore failed: $e");
      rethrow; // Rethrow to handle in controller
    }
  }


    static Future<bool> purchaseProduct(StoreProduct product) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchaseStoreProduct(product);

      // Log the latest customer info for debugging
      print("Customer Info after purchase: ${customerInfo.toJson()}");

      return customerInfo.entitlements.active.containsKey('establish_agency_starter_v2');
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);

      // If the user already owns the product, treat it as success.
      if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError ||
          errorCode == PurchasesErrorCode.productNotAvailableForPurchaseError) {
        print("Subscription already active. Refreshing status...");
        return true; // Return true instead of throwing error
      }

      print("Purchase failed with error: $e");
      rethrow; // Only rethrow if it's a real error
    }
  }

  static Future<bool> isUserSubscribed() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey('establish_agency_starter_v2');
    } catch (e) {
      print("Subscription check error: $e");
      rethrow; // Rethrow to handle in controller
    }
  }
}
