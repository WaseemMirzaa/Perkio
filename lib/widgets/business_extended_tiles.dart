import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
                        offset: const Offset(0, 3)
                      )
                    ]
                                  ),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Column(
                                        children: [
                                          Expanded(
                                            child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                            const SpacerBoxHorizontal(width: 10),

                                            Stack(
                                            alignment: Alignment.topLeft,
                                            clipBehavior: Clip.none,
                                            children: [
                                              Column(
                                                children: [
                                                  SpacerBoxVertical(height: 1.3.h),
                                                  Expanded(child: Image.asset(AppAssets.restaurantImg1,)),
                                                ],
                                              ),

                                            ],
                                                                                ),
                                            const SpacerBoxHorizontal(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SpacerBoxVertical(height: 10),
                                                Text(TempLanguage.txtDealName, style: poppinsMedium(fontSize: 13.sp),),
                                                const SpacerBoxVertical(height: 5),
                                                Text(TempLanguage.txtRestaurantName, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),

                                                const SpacerBoxVertical(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on, color: AppColors.hintText, size: 12.sp,),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Expanded(child: Text('280 Mil', style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),maxLines: 2,)),
                                                          const SpacerBoxHorizontal(width: 4),


                                                        ],
                                                      ),
                                                    )

                                                  ],
                                                ),
                                                  Text("3 People used by now", style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                                                  const Expanded(child: SizedBox()),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: Text(TempLanguage.txtUses3,style: poppinsMedium(fontSize: 13.sp),),
                                                ),
                                                const SpacerBoxVertical(height: 5),
                                                ],
                                              ),
                                            ),

                                                                                ],
                                                                              ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Container(
                                              height: 1,
                                              color: AppColors.borderColor,
                                            ),
                                          ),
                                          const SpacerBoxVertical(height: 5),
                                          Row(
                                            children: [
                                              const SpacerBoxHorizontal(width: 12),
                                              Image.asset(AppAssets.thumbsImg, scale: 3,),
                                              const SpacerBoxHorizontal(width: 5),
                                              Column(
                                                children: [
                                                  Text('203', style: poppinsMedium(fontSize: 10),),
                                                  Text(TempLanguage.txtLikes, style: poppinsMedium(fontSize: 10, color: AppColors.hintText),),
                                                ],
                                              ),
                                              const SpacerBoxHorizontal(width: 20),
                                              Image.asset(AppAssets.viewImg, scale: 3,),
                                              const SpacerBoxHorizontal(width: 5),
                                              Column(
                                                children: [
                                                  Text('203', style: poppinsMedium(fontSize: 10),),
                                                  Text(TempLanguage.txtViews, style: poppinsMedium(fontSize: 10, color: AppColors.hintText),),
                                                ],
                                              ),
                                              const Expanded(child: SpacerBoxHorizontal(width: 5)),
                                              Container(
                                                height: 20,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                                    colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(100),
                                                  ),
                                                  child: Center(
                                                    child: Text(TempLanguage.txtStopPromotion, style: poppinsRegular(fontSize: 8, color: AppColors.whiteColor),),
                                                  ),
                                              ),
                                              const SpacerBoxHorizontal(width: 12),
                                            ],
                                          ),
                                          const SpacerBoxVertical(height: 5),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Image.asset(AppAssets.editImg, scale: 2.5,),
                                                const SpacerBoxHorizontal(width: 10),
                                                Image.asset(AppAssets.deleteImg, scale: 2.5,),
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