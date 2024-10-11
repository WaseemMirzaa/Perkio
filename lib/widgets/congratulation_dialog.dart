import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

void showCongratulationDialog(
    {Function? onDone, String message = "", isPendingforVerification = false}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.congratulationsImg, // Add your image here
              scale: 3,
            ),
            const SpacerBoxVertical(height: 20),
            // General message without remaining uses
            if (isPendingforVerification)
              Text(
                "Your reward has been redeemed successfully.",
                style: poppinsRegular(
                    fontSize: 15, color: AppColors.secondaryText),
                textAlign: TextAlign.center,
              ),
            if (!isPendingforVerification)
              Text(
                "Congratulations! You've successfully redeemed this $message. Enjoy the benefits!",
                style: poppinsRegular(
                    fontSize: 15, color: AppColors.secondaryText),
                textAlign: TextAlign.center,
              ),
            const SpacerBoxVertical(height: 30),
            GestureDetector(
              onTap: onDone != null
                  ? () {
                      onDone();
                    }
                  : () => Get.back(),
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.gradientStartColor,
                      AppColors.gradientEndColor
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                    child: Text(
                  TempLanguage.btnLblDone,
                  style:
                      poppinsMedium(fontSize: 11, color: AppColors.whiteColor),
                )),
              ),
            ),
            const SpacerBoxVertical(height: 10),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // Prevent dismissing by tapping outside
  );
}
