import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class AvailableListItems extends StatelessWidget {
   AvailableListItems({super.key, this.isFeatured = true});
  bool isFeatured;
  @override
  Widget build(BuildContext context) {
    RxBool tapped = false.obs;
    return Container(
      height: 130,
      margin: const EdgeInsets.only(bottom: 10,left: 12,right: 12),
      padding: const EdgeInsets.all(2),
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
                  ]),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Stack(
                                      alignment: Alignment.topLeft,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Column(
                                          children: [
                                            SpacerBoxVertical(height: 1.3.h),
                                            Expanded(child: Image.asset(AppAssets.restaurantImg1)),
                                            Text("\$25",style: poppinsMedium(fontSize: 15.sp),),
                                          ],
                                        ),
                                        Positioned(
                                            left: -0.5.h,
                                            top: -1.h,
                                            child: Obx(
                                                (){
                                              return  IconButton(
                                                  onPressed: () {
                                                    tapped.value = !tapped.value;
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  icon: ImageIcon(AssetImage( tapped.value
                                                      ? AppAssets.likeFilledImg
                                                      : AppAssets.likeImg,
                                                  ),size: 12.sp,color: tapped.value ? AppColors.redColor : AppColors.hintText,)
                                              );
                                            }
                                        ))
                                      ],
                                    ),
                                    const SpacerBoxHorizontal(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SpacerBoxVertical(height: 10),
                                          Text(TempLanguage.txtDealName, style: poppinsMedium(fontSize: 14),),
                                          const SpacerBoxVertical(height: 5),
                                          Text(TempLanguage.txtRestaurantName, style: poppinsRegular(fontSize: 12, color: AppColors.hintText),),
                                          const SpacerBoxVertical(height: 5),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_half, color: AppColors.yellowColor, size: 15,),
                                              Text('4.4', style: poppinsRegular(fontSize: 12, color: AppColors.yellowColor),),
                                              Text('15K', style: poppinsRegular(fontSize: 12, color: AppColors.yellowColor),)

                                            ],
                                          ),
                                          const SpacerBoxVertical(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, color: AppColors.hintText, size: 15.sp,),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(child: Text('4773 Waldeck Street, US', style: poppinsRegular(fontSize: 12, color: AppColors.hintText),maxLines: 2,)),
                                                    const SpacerBoxHorizontal(width: 4),
                                                    
                                                
                                                  ],
                                                ),
                                              )

                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        children: [
                                          const SpacerBoxVertical(height: 10),

                                          isFeatured ? Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 0.5.h),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [Colors.red, Colors.orange],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: Center(child: Text(TempLanguage.txtFeatured, style: poppinsBold(fontSize: 7, color: AppColors.whiteColor),)),
                                                ) : const SizedBox.shrink(),
                                                const SpacerBoxVertical(height: 10),
                                                Text(TempLanguage.txtUses3,style: poppinsMedium(fontSize: 13.sp),)
                                        ],
                                      ),
                                    )
                                   

                                  ],
                                ),

                      );
  }
}