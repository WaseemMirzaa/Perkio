import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Get.toNamed(AppRoutes.signupUser);
              },
              child: Text(TempLanguage.txtNewUser, style: poppinsRegular(fontSize: 13))),
            ],
          ),
          const SpacerBoxVertical(height: 20),
          const AuthTextfield(text: TempLanguage.lblEmailId, path: AppAssets.emailIcon),
          const SpacerBoxVertical(height: 20),
                    const AuthTextfield(text: TempLanguage.lblPassword, path: AppAssets.unlockImg),
                    const SpacerBoxVertical(height: 20),
                    CommonButton(onSwipe: (){
                      Get.to(BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false,));
                    }, text: TempLanguage.btnLblSwipeToLogin),
                    const SpacerBoxVertical(height: 20),
                    Text(TempLanguage.txtForgotPassword, style: poppinsRegular(fontSize: 18, color: AppColors.secondaryText),)

        ],),
      )
    );
  }
}