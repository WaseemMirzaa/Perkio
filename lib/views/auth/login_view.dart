import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/mixins/validate_textfield.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ValidationMixin {

  var controller = Get.find<UserController>();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      controller.clearTextFields();
      return true;
    },
    child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      body:
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Text(TempLanguage.lblSwipe, style: altoysFont(fontSize: 45),textAlign: TextAlign.center,),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(TempLanguage.txtLogin, style: poppinsMedium(fontSize: 18, color: AppColors.hintText)),
            GestureDetector(
              onTap: (){
    controller.clearTextFields();

    Get.toNamed(AppRoutes.signupUser);
              },
              child: Text(getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? TempLanguage.txtNewUser : TempLanguage.txtNewBusiness, style: poppinsRegular(fontSize: 13))),
            ],
          ),
          const SpacerBoxVertical(height: 20),
          AuthTextfield(text: TempLanguage.lblEmailId, path: AppAssets.emailIcon, textController: controller.emailController,),
          const SpacerBoxVertical(height: 20),
            AuthTextfield(text: TempLanguage.lblPassword, path: AppAssets.unlockImg, textController: controller.passwordController,),
                    const SpacerBoxVertical(height: 20),
      Obx(() => controller.loading.value
          ? const CircularProgressIndicator()
          : ButtonWidget(onSwipe: (){
        controller.emailErrorText.value =
            simpleValidation(controller.emailController.text);
        controller.passErrorText.value =
            simpleValidation(controller.passwordController.text);
        if (controller.emailErrorText.value == "" &&
            controller.passErrorText.value == "") {
          controller.signIn(controller.emailController.text,
              controller.passwordController.text);
        } else {
          Get.snackbar('Error', 'Field required');
        }}, text: TempLanguage.btnLblSwipeToLogin)),
                     const SpacerBoxVertical(height: 20),
                    Text(TempLanguage.txtForgotPassword, style: poppinsRegular(fontSize: 18, color: AppColors.secondaryText),)

        ],),
      )
    )
    );
  }
}