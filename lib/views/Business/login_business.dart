import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class LoginBusiness extends StatefulWidget {
  const LoginBusiness({super.key});

  @override
  State<LoginBusiness> createState() => _LoginBusinessState();
}

class _LoginBusinessState extends State<LoginBusiness> {
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
                Get.toNamed(AppRoutes.signupBusiness);
              },
              child: Text(TempLanguage.txtNewUser, style: poppinsRegular(fontSize: 13))),
            ],
          ),
          SpacerBoxVertical(height: 20),
          AuthTextfield(text: TempLanguage.lblEmailId, path: AppAssets.emailIcon),
          SpacerBoxVertical(height: 20),
                    AuthTextfield(text: TempLanguage.lblPassword, path: AppAssets.unlockImg),
                    SpacerBoxVertical(height: 20),
                    CommonButton(onSwipe: (){
                      Get.to(BottomBarView(isUser: false));
                    }, text: TempLanguage.btnLblSwipeToLogin),
                    SpacerBoxVertical(height: 20),
                    Text(TempLanguage.txtForgotPassword, style: poppinsRegular(fontSize: 18, color: AppColors.secondaryText),)

        ],),
      )
    );
  }
}