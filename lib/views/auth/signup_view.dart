import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ?
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3)
                    )]),) : const SizedBox.shrink(),
            const SpacerBoxVertical(height: 20),
            getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ?
            const AuthTextfield(text: TempLanguage.txtUserName, path: AppAssets.userImg)
              :
            const AuthTextfield(text: TempLanguage.txtBusinessName, path: AppAssets.userImg),

            const SpacerBoxVertical(height: 20),

            const AuthTextfield(text: TempLanguage.lblEmailId, path: AppAssets.emailIcon),

            const SpacerBoxVertical(height: 20),

            const AuthTextfield(text: TempLanguage.lblPassword, path: AppAssets.unlockImg),

            const SpacerBoxVertical(height: 20),
            const AuthTextfield(text: TempLanguage.txtDummyPhoneNo, path: 'assets/images/Pwd  Input.png'),
                    const SpacerBoxVertical(height: 20),
                    CommonButton(onSwipe: (){
                     Get.toNamed(AppRoutes.locationChangeScreen);
                    }, text: TempLanguage.btnLblSwipeToSignup),
                    const SpacerBoxVertical(height: 20),
                    Row(
                      children: [
                        const SpacerBoxHorizontal(width: 5),
                        RoundCheckBox(
                          size: 15,
                          checkedWidget: const Icon(Icons.check_rounded,size: 10,color: AppColors.whiteColor,),
                          onTap: (tapped){}),
                        const SpacerBoxHorizontal(width: 5),

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
      )
    );
  }
}