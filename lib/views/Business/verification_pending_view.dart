import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/button_widget.dart';

import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_clipper.dart';

import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';

class VerificationPendingView extends StatelessWidget {
  VerificationPendingView({super.key});
  final userController = UserController(UserServices());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SecondaryLayoutWidget(
        header: ClipPath(
          clipper: CustomMessageClipper(),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              AppColors.gradientStartColor,
              AppColors.gradientEndColor
            ], begin: Alignment.topLeft, end: Alignment.center)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerBoxVertical(height: 40),
                  BackButtonWidget(
                    padding: EdgeInsets.zero,
                    onBack: () {},
                  ),
                  Center(
                      child: Text(
                    'Verification Pending',
                    style: poppinsMedium(
                        fontSize: 25, color: AppColors.whiteColor),
                  ))
                ],
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Equal left and right padding
              child: Center(
                child: Text(
                  'Your account verification status is in ${getStringAsync(UserKey.ISVERIFIED)}. '
                  'Please note that your account will be verified within 24 hours. Swipe team is currently reviewing your information and will notify you once the process is complete. Thank you for your patience!',
                  style:
                      poppinsMedium(fontSize: 16, color: AppColors.blackColor),
                  textAlign: TextAlign.center, // Center-align the text
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
              child: ButtonWidget(
                onSwipe: () async {
                  await userController
                      .getUser(getStringAsync(SharedPrefKey.uid));
                  String verificationStatus =
                      getStringAsync(UserKey.ISVERIFIED);

                  if (verificationStatus == 'verified') {
                    {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationService(
                              child: BottomBarView(
                                  isUser: getStringAsync(SharedPrefKey.role) ==
                                          SharedPrefKey.user
                                      ? true
                                      : false)),
                        ),
                        (route) => false,
                      );
                    }
                    // Do nothing or show a message if needed
                    print('User is verified and cannot swipe.');
                  } else {
                    // Navigate to LocationService if not verified
                  }
                },
                text: 'Verify',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
