import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/detail_tile.dart';

class RewardDetail extends StatefulWidget {
  const RewardDetail({super.key});

  @override
  State<RewardDetail> createState() => _RewardDetailState();
}

class _RewardDetailState extends State<RewardDetail> {
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
                Text('800/1000', style: poppinsRegular(fontSize: 15, color: AppColors.secondaryText),),
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
                          width: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                            colors: [Colors.red, Colors.orange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: -1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(TempLanguage.txtSpendMore, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                                SpacerBoxHorizontal(width: 20),
                                Text("\$10", style: poppinsMedium(fontSize: 10),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SpacerBoxVertical(height: 40),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(
                      AppRoutes.scanScreen
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                              color: AppColors.whiteColor,
                              boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              spreadRadius: 6,
                              offset: Offset(5, 0)
                            )
                          ]
                    ),
                    child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                colors: [Colors.red, Colors.orange],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                        ),
                        child: Image.asset(AppAssets.scannerImg, scale: 3,),
                      ),
                    ),
                  ),
                )
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}