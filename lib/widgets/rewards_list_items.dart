import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class RewardsListItems extends StatelessWidget {
  const RewardsListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10,left: 12,right: 12),
      child: Container(
                          height: 70,
                                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: AppColors.borderColor),
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3)
                      )
                    ]
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SpacerBoxHorizontal(width: 10),
                                     
                                      
                                      Image.asset(AppAssets.restaurantImg1),
                                      SpacerBoxHorizontal(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(TempLanguage.txtBuyOneGetOne, style: poppinsMedium(fontSize: 12),),
                                            SpacerBoxVertical(height: 5),
                                            Row(
              
                                              children: [
                                                Text(TempLanguage.txtBusinessName, style: poppinsRegular(fontSize: 10, color: AppColors.yellowColor),),
                                                SpacerBoxHorizontal(width: 20),
                                                Row(
                                                  
                                                  children: [
                                                    
                                                    Text(TempLanguage.txtPointsAway, style: poppinsRegular(fontSize: 10, color: AppColors.yellowColor),),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                  
                        ),
    );
  }
}