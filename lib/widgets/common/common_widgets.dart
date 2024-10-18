import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/networking/stripe.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'dart:math';
import '../../core/utils/constants/constants.dart';

Future showBalanceDialog({
  required BuildContext context,
  required TextEditingController promotionAmountController,
  required String docId,
  bool fromSettings = false,
}) {
  final homeController = Get.put(HomeController(HomeServices()));
  final controller = Get.put(BusinessController(BusinessServices()));

  // This variable will hold the calculated number of clicks
  ValueNotifier<int> totalClicksNotifier = ValueNotifier(0);

  return showAdaptiveDialog(
      context: context,
      builder: (context) {
        // Add a listener to update the total clicks based on the input
        promotionAmountController.addListener(() {
          // Convert input to budget
          String input = promotionAmountController.text;
          int budget = input.isEmptyOrNull ? 0 : int.parse(input);

          // Safely access apc.value with a fallback value if null
          num apcValue = controller.apc.value ?? 0;

          // Calculate total clicks
          totalClicksNotifier.value = apcValue > 0 ? budget ~/ apcValue : 0;
        });

        return SimpleDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'Promotional Balance',
                  style: poppinsBold(fontSize: 15.sp),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: AppColors.blackColor,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(10.sp),
          insetPadding: EdgeInsets.all(12.sp),
          children: [
            SizedBox(height: 1.h),
            ValueListenableBuilder<int>(
              valueListenable: totalClicksNotifier,
              builder: (context, totalClicks, child) {
                // Ensure controller.apc.value is not null before using it
                return Text(
                  'Amount Per Click / APC : ${controller.apc.value != null && controller.apc.value! > 0 ? controller.apc.value : 'Unavailable'} \$',
                  style: poppinsMedium(fontSize: 12.sp),
                );
              },
            ),
            SizedBox(height: 2.h),
            Text(
              'Enter your budget for promotion',
              style: poppinsMedium(fontSize: 12.sp),
            ),
            SizedBox(height: 1.h),
            TextFieldWidget(
              text: 'Enter your budget for promotion',
              textController: promotionAmountController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onEditComplete: () {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            ValueListenableBuilder<int>(
              valueListenable: totalClicksNotifier,
              builder: (context, totalClicks, child) {
                // Ensure controller.apc.value is not null before using it
                return Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    promotionAmountController.text.isNotEmpty &&
                            (controller.apc.value != null &&
                                controller.apc.value! > 0) &&
                            (promotionAmountController.text.toDouble() %
                                    (controller.apc.value ?? 1) ==
                                0) // Use a default value to avoid division by zero
                        ? 'You will get $totalClicks clicks'
                        : 'Enter your budget to calculate clicks',
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
            ButtonWidget(
              onSwipe: () async {
                String input = promotionAmountController.text;
                int budget = input.isEmptyOrNull ? 0 : int.parse(input);
                num apcValue = controller.apc.value ?? 0;

                if (promotionAmountController.text.isEmptyOrNull) {
                  toast('Please enter your budget');
                } else if (promotionAmountController.text == '0') {
                  toast('Budget should be greater than zero');
                } else if (apcValue > 0 && budget >= 0) {
                  final double budgetInt = budget.toDouble();
                  if (budgetInt % apcValue == 0 && !fromSettings) {
                    await StripePayment.initPaymentSheet(
                            amount: budget * 100,
                            customerId:
                                getStringAsync(UserKey.STRIPECUSTOMERID))
                        .then((value) async {
                      String? currentUID =
                          FirebaseAuth.instance.currentUser!.uid;
                      log('-----------BEFORE PAYMENT ADD currentUID: $currentUID');
                      await homeController
                          .updateCollection(currentUID, CollectionsKey.USERS, {
                        UserKey.ISPROMOTIONSTART: true,
                      }).then((value) async {
                        await homeController
                            .updateCollection(docId, CollectionsKey.DEALS, {
                          DealKey.ISPROMOTIONSTART: true,
                        });
                        await setValue(UserKey.ISPROMOTIONSTART, true);
                        promotionAmountController.clear();

                        toast('You have added an amount to your wallet');
                      });
                    });
                  } else if (budgetInt % apcValue == 0 && fromSettings) {
                    FocusScope.of(context).unfocus();
                    await StripePayment.initPaymentSheet(
                        amount: budget * 100,
                        customerId: getStringAsync(UserKey.STRIPECUSTOMERID));
                    promotionAmountController.clear();
                  } else {
                    toast('Budget must be a multiple of the cost per click.');
                  }
                } else {
                  toast(
                      'Please enter a valid budget and ensure cost per click is greater than zero.');
                }
              },
              text: 'ADD BALANCE',
            ),
          ],
        );
      });
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // Radius of the Earth in kilometers

  double latDistance = _degToRad(lat2 - lat1);
  double lonDistance = _degToRad(lon2 - lon1);
  double a = sin(latDistance / 2) * sin(latDistance / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(lonDistance / 2) *
          sin(lonDistance / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _degToRad(double deg) {
  return deg * (pi / 180.0);
}
