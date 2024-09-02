import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/auth/login_view.dart';
import 'package:swipe_app/widgets/selection_tile.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  GestureDetector(
                    onTap: ()async{
                      await setValue(SharedPrefKey.role, SharedPrefKey.user);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginView()));
                    },
                    child: const SelectionTile(imgPath: AppAssets.userSel, text: 'USER')),
                const SizedBox(width: 20,),
                GestureDetector(
                  onTap: ()async{
                    await setValue(SharedPrefKey.role, SharedPrefKey.business);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginView()));
                  },
                  child: const SelectionTile(imgPath: AppAssets.businessSel, text: 'BUSINESS')),

                ],),
              )
            ],
          ),
        ),
      ),
    );
  }
}