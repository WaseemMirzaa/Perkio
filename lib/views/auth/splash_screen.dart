import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/login_button_widget.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
                flex: 2,
                child: Center(child: Column( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TempLanguage.lblSwipe, style: altoysFont(fontSize: 45, color: AppColors.whiteColor), textAlign: TextAlign.center,),
                    Text(TempLanguage.txtPointsToRedeemPoints, style: poppinsRegular(color: AppColors.whiteColor, fontSize: 16,), textAlign: TextAlign.center,),
                  ],
                )),),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                Text(TempLanguage.txtHowToUse, style: GoogleFonts.poppins(color: AppColors.whiteColor, fontSize: 18,),),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    height: 35.h,
                    
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                       borderRadius: BorderRadius.all(Radius.circular(14)),
                       boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 3)// changes position of shadow
                  ),
                                ],),
                       child: Image.asset(AppAssets.pauseImg, scale: 3,),
                  ),
                ),
                SizedBox(height: 30,),
                LoginButtonWidget(onSwipe: (){
                  Get.toNamed(AppRoutes.selection);
                }, text: TempLanguage.btnLblSwipeToStart),
                ],),
              )
            ],
          ),
        ),
      ),
    );
  }
}