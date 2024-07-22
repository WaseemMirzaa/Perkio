import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
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
                
                SpacerBoxVertical(height: 20),
                DetailTile(),
                SpacerBoxVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TempLanguage.txtDealName, style: poppinsMedium(fontSize: 15),),
                          Text(TempLanguage.txtMilesAway, style: poppinsRegular(fontSize: 12, color: AppColors.hintText),),
                        ],
                      ),
                      Text(TempLanguage.txt3Uses, style: poppinsMedium(fontSize: 14),textAlign: TextAlign.center,),
                    ],
                  )
                ),
                SpacerBoxVertical(height: 20),
                Image.asset(AppAssets.foodImg, scale: 3,),
                SpacerBoxVertical(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: CommonButton(onSwipe: (){
                    Get.toNamed(AppRoutes.rewardDetail);
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