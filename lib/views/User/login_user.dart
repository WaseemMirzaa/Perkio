import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/mixins/validate_textfield.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> with ValidationMixin {

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
        SingleChildScrollView(
          child: Padding(
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
                  child: Text(TempLanguage.txtNewUser, style: poppinsRegular(fontSize: 13))),
                ],
              ),
              SpacerBoxVertical(height: 20),
              AuthTextfield(text: TempLanguage.lblEmailId, path: AppAssets.emailIcon, textController: controller.emailController,),
              SpacerBoxVertical(height: 20),
                        AuthTextfield(text: TempLanguage.lblPassword, path: AppAssets.unlockImg, textController: controller.passwordController,),
                        SpacerBoxVertical(height: 20),
                        Obx(() => controller.loading.value
                    ? const CircularProgressIndicator()
                    : CommonButton(
                        text: TempLanguage.btnLblSwipeToLogin,
                        onSwipe: () {
                          controller.emailErrorText.value =
                              simpleValidation(controller.emailController.text);
                          controller.passErrorText.value =
                              simpleValidation(controller.passwordController.text);
                          if (controller.emailErrorText.value == "" &&
                              controller.passErrorText.value == "") {
                            controller.signInUser(controller.emailController.text,
                                controller.passwordController.text);
                          } else {
                            Get.snackbar('Error', 'Field required');
                          }
                        },
                      )),
                        SpacerBoxVertical(height: 20),
                        Text(TempLanguage.txtForgotPassword, style: poppinsRegular(fontSize: 18, color: AppColors.secondaryText),)
                
            ],),
          ),
        )
      ),
    );
  }
}