import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/notification_controller.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/core/utils/app_utils/location_permission_manager.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/mixins/validate_textfield.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/auth/forget_password_view.dart';
import 'package:swipe_app/views/auth/signup_view.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/location/select_location_view.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/widgets/app_images.dart';
import 'package:swipe_app/widgets/auth_components/authComponents.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart';

class LoginView extends StatefulWidget {
  final bool isUser;
  const LoginView({super.key, required this.isUser});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ValidationMixin {
  var controller = Get.find<UserController>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.clearTextFields();
          return true;
        },
        child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child:
                          // Text(
                          //   TempLanguage.lblSwipe,
                          //   style: altoysFont(fontSize: 45),
                          //   textAlign: TextAlign.center,
                          // ),
                          Image.asset(
                        AppImages.logoBack, // Replace with the correct path to your logo
                        height: 100, // Adjust size as needed
                        fit: BoxFit.contain,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(TempLanguage.txtLogin,
                            style: poppinsMedium(
                                fontSize: 18, color: AppColors.hintText)),
                        GestureDetector(
                            onTap: () {
                              controller.clearTextFields();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupView()));
                            },
                            child: Text(
                                getStringAsync(SharedPrefKey.role) ==
                                        SharedPrefKey.user
                                    ? TempLanguage.txtNewUser
                                    : TempLanguage.txtNewBusiness,
                                style: poppinsRegular(fontSize: 13))),
                      ],
                    ),
                    const SpacerBoxVertical(height: 20),
                    TextFieldWidget(
                      text: TempLanguage.lblEmailId,
                      path: AppAssets.emailIcon,
                      textController: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: emailFocusNode,
                      onEditComplete: () => focusChange(
                          context, emailFocusNode, passwordFocusNode),
                    ),
                    const SpacerBoxVertical(height: 20),
                    TextFieldWidget(
                      text: TempLanguage.lblPassword,
                      path: AppAssets.unlockImg,
                      onChangepath: AppAssets.lockImg,
                      textController: controller.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      focusNode: passwordFocusNode,
                      isPassword: true,
                      onEditComplete: () => unFocusChange(context),
                    ),
                    const SpacerBoxVertical(height: 20),
                    Obx(() => controller.loading.value
                        ? circularProgressBar()
                        : ButtonWidget(
                            onSwipe: () async {
                              controller.emailErrorText.value = validateEmail(
                                  controller.emailController.text);
                              controller.passErrorText.value = validatePassword(
                                  controller.passwordController.text);
                              if (controller.emailErrorText.value == "" &&
                                  controller.passErrorText.value == "") {
                                final isAuthenticated = await controller.signIn(
                                    controller.emailController.text,
                                    controller.passwordController.text,
                                    widget.isUser);
                                controller.fetchAndCacheFavouriteDeals();
                                if (isAuthenticated &&
                                    await LocationPermissionManager
                                        .requestLocationPermissions(context)) {
                                  Get.put(NotificationController());
                                  Get.put(RewardController());
                                  // if(LocationPermissionManager().requestLocationPermissions(context))
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LocationService(
                                              child: BottomBarView(
                                                  isUser: getStringAsync(
                                                              SharedPrefKey
                                                                  .role) ==
                                                          SharedPrefKey.user
                                                      ? true
                                                      : false))));
                                } else if (!await LocationPermissionManager
                                    .requestLocationPermissions(context)) {
                                  showSnackBar('Location Needed',
                                      'Location permissions are needed.');
                                  controller.loading.value = false;
                                } else {
                                  showSnackBar(
                                      'Error', 'Incorrect email and password.');
                                  controller.loading.value = false;
                                }
                              } else {
                                if (controller.emailErrorText.isNotEmpty) {
                                  Get.snackbar('Error',
                                      '${controller.emailErrorText.value}.');
                                } else if (controller
                                    .passErrorText.isNotEmpty) {
                                  Get.snackbar('Error',
                                      '${controller.passErrorText.value}.');
                                } else {
                                  Get.snackbar('Error', 'Field required.');
                                }
                              }
                            },
                            text: TempLanguage.btnLblSwipeToLogin)),
                    SpacerBoxVertical(height: 1.5.h),
                    TextButton(
                      onPressed: () {
                        Get.to(() => ForgotPasswordView(isUser: widget.isUser));
                      },
                      child: Text(
                        TempLanguage.txtForgotPassword,
                        style: poppinsMedium(
                            fontSize: 15.sp, color: AppColors.secondaryText),
                      ),
                    ),
                    SpacerBoxVertical(height: 1.5.h),
                    widget.isUser
                        ? TextButton(
                            onPressed: () {
                              Navigator.push(
                                // user side permissions
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LocationService(
                                    child: SelectLocation(
                                      isGuestUser: true,
                                      isUser: widget.isUser,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Continue as a Guest',
                              style: poppinsMedium(
                                  fontSize: 15.sp,
                                  color: AppColors.secondaryText),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            )));
  }
}
