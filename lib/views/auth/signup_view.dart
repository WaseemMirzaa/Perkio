import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/core/utils/mixins/validate_textfield.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> with ValidationMixin {
  var controller = Get.find<UserController>();
  final RxBool confirm = false.obs;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        controller.clearTextFields();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Text(TempLanguage.lblSwipe, style: altoysFont(fontSize: 45),textAlign: TextAlign.center,),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(TempLanguage.txtSignup, style: poppinsMedium(fontSize: 18)),
                  Text(TempLanguage.txtLogin, style: poppinsRegular(fontSize: 13, color: AppColors.hintText)),
              ],
            ),
              const SpacerBoxVertical(height: 10),
              // getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ?
              // Container(
              //   height: 70,
              //   width: 70,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: AppColors.whiteColor,
              //     boxShadow: [
              //       BoxShadow(
              //           color: Colors.black.withOpacity(0.2),
              //           blurRadius: 6,
              //           offset: const Offset(0, 3)
              //         )]),) : const SizedBox.shrink(),

              const SpacerBoxVertical(height: 20),
              getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ?
              AuthTextfield(text: TempLanguage.txtUserName, path: AppAssets.userImg, textController: controller.userNameController,)
                  :
              AuthTextfield(text: TempLanguage.txtBusinessName, path: AppAssets.userImg, textController: controller.userNameController,),
              const SpacerBoxVertical(height: 20),
              AuthTextfield(text: TempLanguage.lblEmailId, path: AppAssets.emailIcon, textController: controller.emailController,),
              const SpacerBoxVertical(height: 20),
              AuthTextfield(text: TempLanguage.lblPassword, path: AppAssets.unlockImg, textController: controller.passwordController, isPassword: true,),

              const SpacerBoxVertical(height: 20),
        AuthTextfield(text: TempLanguage.txtDummyPhoneNo, path: 'assets/images/Pwd  Input.png', textController: controller.phoneController,),
        const SpacerBoxVertical(height: 20),
        Obx(() => controller.loading.value
            ? const CircularProgressIndicator() :
                      ButtonWidget(onSwipe: (){
                        controller.emailErrorText.value =
                            validateEmail(controller.emailController.text);
                        controller.passErrorText.value =
                            validatePassword(controller.passwordController.text);
                        controller.userNameErrorText.value =
                            simpleValidation(controller.userNameController.text);
                        controller.phoneErrorText.value =
                            simpleValidation(controller.phoneController.text);
                        if (controller.emailErrorText.value == "" &&
                            controller.passErrorText.value == "" &&
                            controller.userNameErrorText.value == "" &&
                            controller.phoneErrorText.value == "") {
                          if (confirm.value) {
                            controller.signUp(
                                controller.emailController.text,
                                controller.passwordController.text,
                                controller.userNameController.text,
                                controller.phoneController.text,
                                getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false
                            );
                          } else {
                            Get.snackbar('Error', 'Please Accept Terms & Conditions To Continue');
                          }
                        } else {
                          Get.snackbar('Error', 'Please Fill Correctly');
                        }
                        // getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? Get.to(()=>SubscriptionPlan(fromSignUp: true,)) :
                        // Get.toNamed(AppRoutes.addBusinessInfo);
                        }, text: TempLanguage.btnLblSwipeToSignup)),
                      const SpacerBoxVertical(height: 20),
                      Row(
                        children: [
                          const SpacerBoxHorizontal(width: 5),
                          RoundCheckBox(
                              size: 15,
                              checkedWidget: const Icon(Icons.check_rounded,size: 10,color: AppColors.whiteColor,),
                              onTap: (tapped){
                                confirm.value = tapped!;
                              }),
                          const SpacerBoxHorizontal(width: 5),
                          Text('Accept Terms & Condition', style: poppinsRegular(fontSize: 15, color: AppColors.secondaryText),),
                          const SizedBox(width: 10,),
                          socialIconsComp(icon: AppAssets.appleIcon,bgColor: AppColors.blackColor),
                          const SizedBox(width: 10,),
                          socialIconsComp(icon: 'assets/images/google_icon.png',bgColor: Colors.orange),

                        ],
                      )

          ],),
        )
      ),
    );
  }
  Widget socialIconsComp({Function()? onTap, required String icon,required Color bgColor})=> GestureDetector(
    onTap: onTap,
    child: Container(height:  28.sp,width: 28.sp,decoration: BoxDecoration(
      color: bgColor,
        boxShadow:[
          BoxShadow(color: AppColors.blackColor.withOpacity(0.16),offset: const Offset(0,3), blurRadius: 3)
        ],
        shape: BoxShape.circle,
        border: Border.all(width: 2,color: AppColors.whiteColor),
    ),child: Center(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(icon),
    ),),),
  );
}

/*
*
* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/core/utils/mixins/validate_textfield.dart';
import 'package:skhickens_app/widgets/activation_dialog.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class SignupBusiness extends StatefulWidget {
  const SignupBusiness({super.key});

  @override
  State<SignupBusiness> createState() => _SignupBusinessState();
}

class _SignupBusinessState extends State<SignupBusiness> with ValidationMixin {

  var controller = Get.find<UserController>();
  final RxBool confirm = false.obs;

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
                children: [Text(TempLanguage.txtSignup, style: poppinsMedium(fontSize: 18)),
                Text(TempLanguage.txtLogin, style: poppinsRegular(fontSize: 13, color: AppColors.hintText)),
                ],
              ),
              SpacerBoxVertical(height: 10),
              Container(height: 70,
                          width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.whiteColor,
                                        boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3)
                        )
                                        ]
                                      ),),
              SpacerBoxVertical(height: 20),
              AuthTextfield(text: TempLanguage.txtBusinessName, path: AppAssets.userImg, textController: controller.userNameController,),

              SpacerBoxVertical(height: 20),
              AuthTextfield(text: TempLanguage.lblEmailId, path: AppAssets.emailIcon, textController: controller.emailController,),
              SpacerBoxVertical(height: 20),
                        AuthTextfield(text: TempLanguage.lblPassword, path: AppAssets.unlockImg, textController: controller.passwordController, isPassword: true,),
                SpacerBoxVertical(height: 20),
                AuthTextfield(text: TempLanguage.txtDummyPhoneNo, path: 'assets/images/Pwd  Input.png', textController: controller.phoneController,),
                        SpacerBoxVertical(height: 20),
                        Obx(() => controller.loading.value
                      ? const CircularProgressIndicator()
                      : CommonButton(
                          text: TempLanguage.btnLblSwipeToSignup,
                          onSwipe: () {
                            controller.emailErrorText.value =
                                validateEmail(controller.emailController.text);
                            controller.passErrorText.value =
                                validatePassword(controller.passwordController.text);
                            controller.userNameErrorText.value =
                                simpleValidation(controller.userNameController.text);
                            controller.phoneErrorText.value =
                                simpleValidation(controller.phoneController.text);
                            if (controller.emailErrorText.value == "" &&
                                controller.passErrorText.value == "" &&
                                controller.userNameErrorText.value == "" &&
                                controller.phoneErrorText.value == "") {
                              if (confirm.value) {
                                controller.signUpBusiness(
                                    controller.emailController.text,
                                    controller.passwordController.text,
                                    controller.userNameController.text,
                                    controller.phoneController.text);
                              } else {
                                Get.snackbar('Error', 'Please Accept Terms & Conditions To Continue');
                              }
                            } else {
                              Get.snackbar('Error', 'Please Fill Correctly');
                            }
                          },
                        )),
                        SpacerBoxVertical(height: 20),
                        Row(
                          children: [
                            SpacerBoxHorizontal(width: 5),
                            RoundCheckBox(
                              size: 15,
                              checkedWidget: Icon(Icons.check_rounded,size: 10,color: AppColors.whiteColor,),
                              onTap: (tapped){
                                confirm.value = tapped!;
                              }),
                            SpacerBoxHorizontal(width: 5),

                            Text('Accept Terms & Condition', style: poppinsRegular(fontSize: 15, color: AppColors.secondaryText),),
                            SizedBox(
                              width: 50,
                              child: Image.asset(AppAssets.facebookImg,)),
                            SizedBox(
                              width: 50,
                              child: Image.asset(AppAssets.googleImg,)),


                          ],
                        )

            ],),
          ),
        )
      ),
    );
  }
}
* */
