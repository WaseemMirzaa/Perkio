import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/login_button_widget.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.gradientStartColor,AppColors.gradientEndColor],begin: Alignment.topCenter, end: Alignment.bottomCenter)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(child: Text(TempLanguage.lblSwipe, style: altoysFont(fontSize: 45, color: AppColors.whiteColor),textAlign: TextAlign.center,)),),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                LoginButtonWidget(onSwipe: (){
                  Get.toNamed(AppRoutes.loginUser);
                }, text: TempLanguage.lblUser),
                SizedBox(height: 20,),
                LoginButtonWidget(onSwipe: (){
                  Get.toNamed(AppRoutes.loginBusiness);
                }, text: TempLanguage.lblBusiness),
                ],),
              )
            ],
          ),
        ),
      ),
    );
  }
}