import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/controllers/home_controller.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/services/home_services.dart';
import 'package:skhickens_app/services/user_services.dart';
import '../core/utils/constants/app_const.dart';
import '../core/utils/constants/constants.dart';
import 'dio_helper.dart';


class StripePayment {

  static final homeController = Get.put(HomeController(HomeServices()));
  static final userController = Get.put(UserController(UserServices()));

  static Future<String> createStripeCustomer({required String email}) async {
    String params = DioHelper.getJsonString({"email": email});
    String completeUrl = '${DioHelper.baseURL}createStripeCustomer';
    dynamic response = await DioHelper.postRawData(completeUrl, params);
    if (response.body != null) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data["customerId"];
    } else {
      throw Exception(DioHelper.apiErrorResponse);
    }
  }

  static Future<Map<String, dynamic>?> createPaymentSheet(
      {required int amount, required String customerId}) async {
    String params = DioHelper.getJsonString({
      "amount": amount,
      "customerId": customerId,
    });

    var completeUrl = '${DioHelper.baseURL}initPaymentSheet';
    if (kDebugMode) {
      print('URL: $completeUrl');
    }
    ApiResponse response = await DioHelper.postRawData(completeUrl, params);
    if (response.body != null) {
      if (kDebugMode) {
        print(response.body);
      }
      Map<String, dynamic> mapData = json.decode(response.body);

      return mapData;
    } else {
      log('Stripe Response: ${response.body}--');
      return null;
    }
  }

  static Future<void> initPaymentSheet({
    required int amount,
    required String customerId,
  }) async {
    try {
      final data = await createPaymentSheet(amount: amount, customerId: customerId);
      var customer = data?['customer'] ?? '';
      //String? paymentIntent = data?['paymentIntent'];
      var clientSecret = data?['clientSecret'] ?? '';
      var ephemeralKey = data?['ephemeralKey'] ?? '';
      if (clientSecret.isNotEmpty) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Swipe',
            customerId: customerId,
            applePay: const PaymentSheetApplePay(
              merchantCountryCode: 'US',
            ),
            googlePay: const PaymentSheetGooglePay(
              currencyCode: 'USD',
              merchantCountryCode: 'US',
            ),
            customerEphemeralKeySecret: ephemeralKey,
            style: ThemeMode.dark,
          ),
        );
        await Stripe.instance.presentPaymentSheet();

        /// add user firebase logic
        final userInfo = await userController.getUser(getStringAsync(SharedPrefKey.uid));
        if (userInfo != null) {
          print("The past $amount");
          int currentBalance = userInfo.balance ?? 0;
          double newAmount = amount/100;
          print("After division $newAmount");
          int updateAmount = currentBalance + newAmount.toInt();
          print("Amount is: $updateAmount");
          await homeController.updateCollection(getStringAsync(SharedPrefKey.uid), CollectionsKey.USERS, {
            UserKey.BALANCE: updateAmount,
          }).then((value) async {
            await setValue(UserKey.BALANCE, updateAmount).then((value) => Get.back());
            toast('You have added amount in your wallet');
          });

          /// add user firebase logic
        }
      } } catch (e) {
      toast('Something went wrong. Try again later');
    }
}
}