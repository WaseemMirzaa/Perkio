import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/views/auth/login_view.dart';

class LoginRequiredDialog {
  static void show(BuildContext context, bool isUser) {
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
              Text(
                'Login Required',
                style: poppinsBold(fontSize: 15.sp),
              ),
              const SpacerBoxVertical(height: 10),
              Text(
                'Please sign up or login to access this feature.',
                style: poppinsRegular(
                  fontSize: 15,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SpacerBoxVertical(height: 30),
              // Cancel Button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: AppColors.gradientStartColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: poppinsMedium(
                        fontSize: 11,
                        color: AppColors.gradientStartColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SpacerBoxVertical(height: 10),
              // Login/Sign Up Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.offAll(() => LoginView(isUser: isUser));
                },
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
                      'Login/Sign Up',
                      style: poppinsMedium(
                        fontSize: 11,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SpacerBoxVertical(height: 10),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
