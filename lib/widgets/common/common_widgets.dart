import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/networking/stripe.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart';

import '../../core/utils/constants/constants.dart';
Future showBalanceDialog({
  required BuildContext context,
  required TextEditingController promotionAmountController,
  required String docId,
  bool fromSettings = false,
}) {
  final homeController = Get.put(HomeController(HomeServices()));
  final controller = Get.put(BusinessController(BusinessServices()));
  return showAdaptiveDialog(context: context, builder: (context) =>
      StatefulBuilder(
          builder: (context, function) {
             String input = promotionAmountController.text;
             int budget = input.isEmptyOrNull ? 0 : int.parse(input);
             int totalClicks = budget == null ? 0 : budget ~/ controller.apc.value!;
            return SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 10),
                    child: Text('Promotional Balance',
                      style: poppinsBold(fontSize: 15.sp),),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(onPressed: () {
                      Navigator.pop(context);
                    },
                        icon: const Icon(Icons.cancel,
                          color: AppColors.blackColor,
                          size: 40,)),
                  ),
                ],
              ),
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.all(10.sp),
              insetPadding: EdgeInsets.all(12.sp),
              children: [

                SizedBox(height: 1.h,),
                Text('Amount Per Click / APC : ${controller.apc}\$',
                  style: poppinsMedium(fontSize: 12.sp),),
                SizedBox(height: 2.h,),

                Text('Enter your budget for promotion',
                  style: poppinsMedium(fontSize: 12.sp),),
                SizedBox(height: 1.h,),
                TextFieldWidget(
                  text: 'Enter your budget for promotion',
                  textController: promotionAmountController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onEditComplete: () {
                    FocusScope.of(context).unfocus();
                  },

                  keyboardType: TextInputType.number,),
                SizedBox(height: 2.h,),

                Align(alignment: Alignment.topRight,
                  child: (promotionAmountController.text.toDouble() % controller.apc.value! == 0)
                      ? Text('You will get $totalClicks clicks')
                      : Text(
                    'Budget is not multiple to the Number of clicks',
                    style: poppinsRegular(fontSize: 10.sp, color: AppColors.gradientStartColor),),),

                SizedBox(height: 3.h,),
                ButtonWidget(onSwipe: () async {
                  if (promotionAmountController.text.isEmptyOrNull) {
                    toast('Please enter your budget');
                  } else if(promotionAmountController.text == '0'){
                    toast('Budget should greater than zero');
                  } else if (budget != null && controller.apc.value! > 0 && budget >= 0) {
                    input = promotionAmountController.text;
                    budget = input.isEmptyOrNull ? 0 : int.parse(input);
                    totalClicks = budget == null ? 0 : budget ~/ controller.apc.value!;
                    final double budgetInt = budget.toDouble();
                    if (budgetInt % controller.apc.value! == 0 && !fromSettings) {
                      await StripePayment.initPaymentSheet(amount: budget * 100, customerId: getStringAsync(UserKey.STRIPECUSTOMERID)).then((value)async{
                          await homeController.updateCollection(getStringAsync(getStringAsync(UserKey.USERID)), CollectionsKey.USERS, {
                            UserKey.ISPROMOTIONSTART: true,
                          }).then((value) async{
                            await homeController.updateCollection(docId, CollectionsKey.DEALS, {
                              DealKey.ISPROMOTIONSTART: true,
                            });
                            await setValue(UserKey.ISPROMOTIONSTART, true);
                            promotionAmountController.clear();

                            toast('You have added amount in your wallet');
                          });
                      });
                    }else if(budgetInt % controller.apc.value! == 0 && fromSettings){
                      await StripePayment.initPaymentSheet(amount: budget * 100, customerId: getStringAsync(UserKey.STRIPECUSTOMERID)).then((value)async{
                        Get.back();
                      });
                    } else {
                      toast('Budget must be a multiple of the cost per click.');
                    }
                  } else {
                    toast('Please enter a valid budget and ensure cost per click is greater than zero.');
                  }
                }, text: 'ADD BALANCE')


              ],

            );
          }
      ));
}