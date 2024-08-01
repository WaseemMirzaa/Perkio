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
import 'package:skhickens_app/widgets/auth_components/authComponents.dart';
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
        body: SingleChildScrollView(
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
                TextFieldWidget(text: TempLanguage.txtUserName, path: AppAssets.userImg,
                  textController: controller.userNameController,keyboardType: TextInputType.name,
                  focusNode: controller.nameFocusNode,
                  onEditComplete: ()=> focusChange(context, controller.nameFocusNode, controller.emailFocusNode),)
                    :
                TextFieldWidget(text: TempLanguage.txtBusinessName, path: AppAssets.userImg,
                    textController: controller.userNameController,keyboardType: TextInputType.name,
                    focusNode: controller.nameFocusNode,
                    onEditComplete: ()=> focusChange(context, controller.nameFocusNode, controller.emailFocusNode)),

                const SpacerBoxVertical(height: 20),

                TextFieldWidget(text: TempLanguage.lblEmailId, path: AppAssets.emailIcon,
                  textController: controller.emailController,keyboardType: TextInputType.emailAddress,
                  focusNode: controller.emailFocusNode,
                  onEditComplete: ()=> focusChange(context, controller.emailFocusNode, controller.passwordFocusNode),),

                const SpacerBoxVertical(height: 20),

                TextFieldWidget(text: TempLanguage.lblPassword, path: AppAssets.unlockImg,
                  textController: controller.passwordController, isPassword: true,
                  keyboardType: TextInputType.visiblePassword,focusNode: controller.passwordFocusNode,
                  onEditComplete: ()=> focusChange(context, controller.passwordFocusNode, controller.phoneFocusNode),),

                const SpacerBoxVertical(height: 20),

                TextFieldWidget(text: TempLanguage.txtDummyPhoneNo, path: 'assets/images/Pwd  Input.png',
                  textController: controller.phoneController,focusNode: controller.phoneFocusNode,keyboardType: TextInputType.phone,onEditComplete: ()=> unFocusChange(context),),

                const SpacerBoxVertical(height: 20),

                Obx(() => controller.loading.value
                    ? const CircularProgressIndicator() :
                        ButtonWidget(onSwipe: (){
                          controller.emailErrorText.value = validateEmail(controller.emailController.text);
                          controller.passErrorText.value = validatePassword(controller.passwordController.text);
                          controller.userNameErrorText.value = simpleValidation(controller.userNameController.text);
                          controller.phoneErrorText.value = simpleValidation(controller.phoneController.text);
                          if (controller.emailErrorText.value == "" && controller.passErrorText.value == "" && controller.userNameErrorText.value == "" && controller.phoneErrorText.value == "") {
                            if (confirm.value) {
                              controller.signUp(controller.emailController.text, controller.passwordController.text, controller.userNameController.text, controller.phoneController.text,
                                  getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false
                              );
                            } else {
                              Get.snackbar('Error', 'Please Accept Terms & Conditions To Continue');
                            }
                          } else {
                            if(controller.userNameErrorText.value.isNotEmpty){
                              Get.snackbar('Error', controller.userNameErrorText.value);
                            } else if(controller.emailErrorText.value.isNotEmpty){
                              Get.snackbar('Error', controller.emailErrorText.value);
                            } else if(controller.passErrorText.value.isNotEmpty){
                              Get.snackbar('Error', controller.passErrorText.value);
                            }else if(controller.phoneErrorText.value.isNotEmpty){
                              Get.snackbar('Error', controller.phoneErrorText.value);
                            }else{
                              Get.snackbar('Error', 'Please fill all fields');
                            }
                          }
                          }, text: TempLanguage.btnLblSwipeToSignup)),
                        const SpacerBoxVertical(height: 20),
                        Obx(()=> Row(
                            children: [
                              const SpacerBoxHorizontal(width: 5),
                              RoundCheckBox(
                                  size: 20.sp,
                                  border: Border.all(color: confirm.value ? Colors.green : Colors.grey),
                                  isChecked: confirm.value,
                                  checkedWidget: Icon(Icons.check_rounded,size: 10.sp,color: AppColors.whiteColor,),
                                  onTap: (tapped)=> confirm.value =! confirm.value),
                              const SpacerBoxHorizontal(width: 5),
                              Text('Accept Terms & Condition', style: poppinsRegular(fontSize: 15, color: AppColors.secondaryText),),
                              const SizedBox(width: 10,),
                              socialIconsComp(icon: AppAssets.appleIcon,bgColor: AppColors.blackColor),
                              const SizedBox(width: 10,),
                              socialIconsComp(icon: 'assets/images/google_icon.png',bgColor: Colors.orange),

                            ],
                          ),
                        )

            ],),
          ),
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