import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static Future<void> init() async {
    await Purchases.setDebugLogsEnabled(true);

    String apiKey = Platform.isAndroid
        ? 'goog_SFVBBIuzwEmVLXfudbSBzVMfHGh' // Android API Key
        : 'appl_rlskQNVQHfwDPQbaFJCDVfPEHlM'; // iOS API Key

    await Purchases.configure(PurchasesConfiguration(apiKey));
  }

  /// Fetch available offerings
  static Future<Offering?> getCurrentOffering() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      print("Error fetching offering: $e");
      return null;
    }
  }

  static Future<bool> purchaseProduct(StoreProduct product) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchaseStoreProduct(product);
      return customerInfo.entitlements.active.containsKey('entl9a24d4749e');
    } catch (e) {
      print("Purchase failed: $e");
      return false;
    }
  }

  static Future<void> restorePurchases() async {
    try {
      await Purchases.restorePurchases();
    } catch (e) {
      print("Restore failed: $e");
    }
  }

  static Future<bool> isUserSubscribed() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey('entl9a24d4749e');
    } catch (e) {
      print("Subscription check error: $e");
      return false;
    }
  }
}
