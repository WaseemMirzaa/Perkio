import 'package:in_app_purchase/in_app_purchase.dart';

class BillingService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  Future<void> initStore() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      print("Store not available");
      return;
    }

    const Set<String> kProductIds = {'your_subscription_id'};
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(kProductIds);

    if (response.notFoundIDs.isNotEmpty) {
      print("Product not found");
      return;
    }

    List<ProductDetails> products = response.productDetails;
    print("Products available: ${products.map((e) => e.title)}");
  }

  void buySubscription(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
