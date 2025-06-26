import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/core/utils/mixins/validate_textfield.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/widgets/app_images.dart';
import 'package:swipe_app/widgets/auth_components/authComponents.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/customize_slide_btn_comp.dart';

class ForgotPasswordView extends StatefulWidget {
  final bool isUser;
  const ForgotPasswordView({super.key, required this.isUser});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with ValidationMixin {
  var controller = Get.find<UserController>();

  FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearTextFields();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child:
                      // Text(
                      //   TempLanguage.lblSwipe,
                      //   style: altoysFont(fontSize: 45),
                      //   textAlign: TextAlign.center,
                      // ),
                     Image.asset(
                    AppImages.perkioBold, // Replace with the correct path to your logo
                   scale: 6, // Adjust size as needed
                    fit: BoxFit.contain,
                  ),
                ),
                const SpacerBoxVertical(height: 20),
                Text(
                  TempLanguage.txtEnterEmailToResetPassword,
                  style:
                      poppinsRegular(fontSize: 14, color: AppColors.hintText),
                  textAlign: TextAlign.left,
                ),
                const SpacerBoxVertical(height: 30),
                TextFieldWidget(
                  text: TempLanguage.lblEmailId,
                  path: AppAssets.emailIcon,
                  textController: controller.resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: emailFocusNode,
                  onEditComplete: () => unFocusChange(context),
                ),
                const SpacerBoxVertical(height: 20),
                Obx(
                  () => controller.loading.value
                      ? circularProgressBar() // Show loading spinner if processing
                      : CustomSlideActionButton(
                    outerColor: AppColors.primaryColor, // Red button background
                    innerColor: AppColors.whiteColor, // White slider background
                    sliderButtonIconAsset: AppImages.logoWhite, // White logo
                    text: TempLanguage.btnLblResetPassword,
                    textStyle: poppinsMedium(
                        fontSize: 15.sp,
                        color: AppColors.whiteColor,
                    ),

                      onSubmit: () async {
                            // Call controller's sendPasswordReset method
                            await controller.sendPasswordReset(
                              controller.resetEmailController.text,
                              widget.isUser,
                            );

                            // No need to handle success or failure here, controller takes care of it
                          },
                          // text: TempLanguage.btnLblResetPassword,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
