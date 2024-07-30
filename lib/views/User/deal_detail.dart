import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/congratulation_dialog.dart';
import 'package:skhickens_app/widgets/detail_tile.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class DealDetail extends StatefulWidget {
  const DealDetail({super.key});

  @override
  State<DealDetail> createState() => _DealDetailState();
}

class _DealDetailState extends State<DealDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Image.asset(AppAssets.imageHeader),
          BackButtonWidget(),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              children: [
                
                const SpacerBoxVertical(height: 20),
                const DetailTile(),
                const SpacerBoxVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TempLanguage.txtDealName, style: poppinsMedium(fontSize: 13.sp),),
                          Text(TempLanguage.txtMilesAway, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                        ],
                      ),
                      Text(TempLanguage.txt3Uses, style: poppinsMedium(fontSize: 14),textAlign: TextAlign.center,),
                    ],
                  )
                ),
                const SpacerBoxVertical(height: 20),
                Image.asset(AppAssets.foodImg, scale: 3,),
                const SpacerBoxVertical(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ButtonWidget(onSwipe: (){
                    showCongratulationDialog(onDone: (){
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.bottomBarView,(route)=>false);
                    });
                  }, text: TempLanguage.btnLblSwipeToRedeem),
                )
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}