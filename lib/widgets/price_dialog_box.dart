import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/views/user/reward_redeem_detail.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/price_textfield.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart';

void showPriceInputDialog({
  required String rewardId,
  required String userId,
  required RewardModel rewardModel,
  required Future<int> Function(String, String) getRemainingPoints,
  required Future<void> Function(String, String, int) addPointsToReward,
  required Future<void> Function(String, String) updateRewardUsage,
}) async {
  TextEditingController amountController = TextEditingController();
  RxInt remainingPoints = 0.obs; // Observable to update UI in real time

  // Fetch the remaining points initially
  remainingPoints.value = await getRemainingPoints(rewardId, userId);

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      child: Obx(() => Container(
            width: Get.width * 0.85,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price",
                  style:
                      poppinsMedium(fontSize: 24, color: AppColors.blackColor),
                ),
                const SpacerBoxVertical(height: 10),
                Text(
                  "Enter the amount of dollars you are spending",
                  style: poppinsRegular(
                      fontSize: 15, color: AppColors.secondaryText),
                  textAlign: TextAlign.start,
                ),
                const SpacerBoxVertical(height: 10),
                PriceTextFieldWidget(controller: amountController),
                const SpacerBoxVertical(height: 10),
                Text(
                  "Remaining Points: ${remainingPoints.value}",
                  style:
                      poppinsRegular(fontSize: 14, color: AppColors.blackColor),
                ),
                const SpacerBoxVertical(height: 20),
                ButtonWidget(
                  text: "Continue",
                  onSwipe: () async {
                    int pointsToAdd =
                        (double.parse(amountController.text) * 100).toInt();

                    // if (pointsToAdd > remainingPoints.value) {
                    //   showSnackBar(
                    //     'Invalid Input',
                    //     'You cannot enter more than ${remainingPoints.value / 100} dollars.',
                    //   );
                    //   return; // Don't close the dialog
                    // }

                    // Update points in database
                    await addPointsToReward(rewardId, userId, pointsToAdd);

                    // await updateRewardUsage(rewardId, userId);

                    Get.offAll(() => RewardRedeemDetail(
                          rewardId: rewardModel.rewardId,
                          businessId: rewardModel.businessId,
                          userId: userId,
                        ));
                  },
                ),
                const SpacerBoxVertical(height: 10),
              ],
            ),
          )),
    ),
    barrierDismissible: false, // Prevent user from dismissing dialog manually
  );
}
