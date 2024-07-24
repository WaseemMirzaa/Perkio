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
                          height: 125,
                                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: AppColors.borderColor),
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3)
                      )
                    ]
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SpacerBoxHorizontal(width: 10),
                                     
                                      
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Image.asset(AppAssets.restaurantImg1, scale: 2,),
                                      ),
                                      const SpacerBoxHorizontal(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SpacerBoxVertical(height: 10),
                                            Text(TempLanguage.txtRewardName, style: poppinsMedium(fontSize: 14),),
                                            const SpacerBoxVertical(height: 5),
                                            Text(TempLanguage.txtRestaurantName, style: poppinsRegular(fontSize: 12, color: AppColors.hintText),),
                                            const SpacerBoxVertical(height: 5),
                                            Text(TempLanguage.txtPointsAway, style: poppinsRegular(fontSize: 12, color: AppColors.hintText),),
                                            const SpacerBoxVertical(height: 10),
                                            Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                Container(
                                                  height: 6,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.grey[200],
                                                    boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.2),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 3)
                                                  )
                                                ]
                                                  ),
                                                ),
                                                Container(
                                                  height: 6,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    gradient: const LinearGradient(
                                                    colors: [Colors.red, Colors.orange],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  ),
                                                ),
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