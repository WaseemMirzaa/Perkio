import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class BusinessExtendedTiles extends StatelessWidget {
  const BusinessExtendedTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10,left: 12,right: 12),
      child: Container(
                          height: 185,
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
                                  child: Column(
                                    children: [
                                      Padding(
                                            padding: const EdgeInsets.only(top: 8,right: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Image.asset(AppAssets.editImg, scale: 2.5,),
                                                SpacerBoxHorizontal(width: 10),
                                                Image.asset(AppAssets.deleteImg, scale: 2.5,),
                                              ],
                                            ),
                                          ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SpacerBoxHorizontal(width: 10),
                                          
                                          Column(
                                            children: [
                                              Image.asset(AppAssets.restaurantImg1, scale: 2.2,),
                                              Text('\$25', style: poppinsMedium(fontSize: 14),)
                                            ],
                                          ),
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
                                                    ),
                                                  ],
                                                ),
                                                SpacerBoxVertical(height: 5),
                                                Text('3 USES', style: poppinsRegular(fontSize: 10, color: AppColors.blueColor),),
                                      
                                              ],
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                      SpacerBoxVertical(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Container(
                                          height: 1,
                                          color: AppColors.borderColor,
                                        ),
                                      ),
                                      SpacerBoxVertical(height: 5),
                                      Row(
                                        children: [
                                          SpacerBoxHorizontal(width: 12),
                                          Image.asset(AppAssets.thumbsImg, scale: 3,),
                                          SpacerBoxHorizontal(width: 5),
                                          Column(
                                            children: [
                                              Text('203', style: poppinsMedium(fontSize: 10),),
                                              Text(TempLanguage.txtLikes, style: poppinsMedium(fontSize: 10, color: AppColors.hintText),),
                                            ],
                                          ),
                                          SpacerBoxHorizontal(width: 20),
                                          Image.asset(AppAssets.viewImg, scale: 3,),
                                          SpacerBoxHorizontal(width: 5),
                                          Column(
                                            children: [
                                              Text('203', style: poppinsMedium(fontSize: 10),),
                                              Text(TempLanguage.txtViews, style: poppinsMedium(fontSize: 10, color: AppColors.hintText),),
                                            ],
                                          ),
                                          Expanded(child: SpacerBoxHorizontal(width: 5)),
                                          Container(
                                            height: 20,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                                colors: [Colors.red, Colors.orange],
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                              ),
                                                              borderRadius: BorderRadius.circular(100),
                                              ),
                                              child: Center(
                                                child: Text(TempLanguage.txtStopPromotion, style: poppinsRegular(fontSize: 8, color: AppColors.whiteColor),),
                                              ),
                                          ),
                                          SpacerBoxHorizontal(width: 12),
                                        ],
                                      )
                                    ],
                                  ),
                                  
                        ),
    );
  }
}