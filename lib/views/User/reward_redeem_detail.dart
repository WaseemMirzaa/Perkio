import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/congratulation_dialog.dart';
import 'package:skhickens_app/widgets/detail_tile.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class RewardRedeemDetail extends StatefulWidget {
  const RewardRedeemDetail({super.key});

  @override
  State<RewardRedeemDetail> createState() => _RewardRedeemDetailState();
}

class _RewardRedeemDetailState extends State<RewardRedeemDetail> {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TempLanguage.txtRewardInfo, style: poppinsMedium(fontSize: 15),),
                      SpacerBoxVertical(height: 10),
                      Text(TempLanguage.txtLoremIpsumShort, style: poppinsRegular(fontSize: 15, color: AppColors.hintText),),
                    ],
                  )
                ),
                SpacerBoxVertical(height: 20),
                Text(TempLanguage.txtPoints, style: poppinsBold(fontSize: 15, color: AppColors.secondaryText),),
                SpacerBoxVertical(height: 10),
                Text('1000/1000', style: poppinsRegular(fontSize: 15, color: AppColors.secondaryText),),
                SpacerBoxVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    height: 45,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[200],
                            boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3)
                          )
                        ]
                          ),
                        ),
                        Container(
                          height: 20,
                          
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                            colors: [Colors.red, Colors.orange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                SpacerBoxVertical(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: CommonButton(onSwipe: (){
                    showCongratulationDialog();
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

