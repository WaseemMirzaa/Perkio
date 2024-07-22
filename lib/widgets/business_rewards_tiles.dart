import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class BusinessRewardsTiles extends StatelessWidget {
  const BusinessRewardsTiles({super.key});

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
                                                    Icon(Icons.location_on, color: AppColors.yellowColor, size: 10,),
                                                    Text(TempLanguage.txtMil, style: poppinsRegular(fontSize: 10, color: AppColors.yellowColor),),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SpacerBoxVertical(height: 5),
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
                                                    offset: Offset(0, 3)
                                                  )
                                                ]
                                                  ),
                                                ),
                                                Container(
                                                  height: 6,
                                                  width: 102,
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
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Image.asset(AppAssets.editImg, scale: 3,),
                                                SpacerBoxHorizontal(width: 10),
                                                Image.asset(AppAssets.deleteImg, scale: 3,),
                                              ],
                                            ),
                                            
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  
                        ),
    );
  }
}