import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/app_utils/GeoLocationHelper.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/services/user_services.dart';
import 'package:skhickens_app/views/Business/verification_pending_view.dart';
import 'package:skhickens_app/views/auth/login_view.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/views/role_selection/role_selection_view.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userController = Get.put(UserController(UserServices()));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      print("ID is ${currentUser?.uid}");
      if (currentUser?.uid != null) {
        final user = await userController.getUser(currentUser!.uid);

        if (user != null) {

          userController.userModel.value = user;
          final address = await GeoLocationHelper.getCityFromGeoPoint(user!.latLong!);

          if(!address.isEmptyOrNull){
            await setValue(SharedPrefKey.address, address);
          }
          if(userController.userModel.value.isVerified == StatusKey.verified) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user
                ? true
                : false)),(route)=>false);
                // BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user
                //     ? true
                //     : false));
          }else{
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> VerificationPendingView()), (route)=>false);
          }
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginView()), (route)=> false);
        }
      } else {

      }
    });
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Center(child: Column( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(TempLanguage.lblSwipe, style: altoysFont(fontSize: 45, color: AppColors.whiteColor), textAlign: TextAlign.center,),
                  Text(TempLanguage.txtPointsToRedeemPoints, style: poppinsRegular(color: AppColors.whiteColor, fontSize: 16,), textAlign: TextAlign.center,),
                ],
              )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

              Text(TempLanguage.txtHowToUse, style: GoogleFonts.poppins(color: AppColors.whiteColor, fontSize: 18,),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                     borderRadius: const BorderRadius.all(Radius.circular(14)),
                     boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3)// changes position of shadow
                ),
                              ],),
                     child: Image.asset(AppAssets.pauseImg, scale: 3,),
                ),
              ),
              const SizedBox(height: 30,),
              ButtonWidget(onSwipe: (){

                Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectionScreen()));
              }, text: TempLanguage.btnLblSwipeToStart,isGradient: false,),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}