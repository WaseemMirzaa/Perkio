import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/modals/reward_modal.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/views/Business/edit_my_deal.dart';
import 'package:swipe_app/views/Business/edit_rewards.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class BusinessRewardsTiles extends StatelessWidget {
  BusinessRewardsTiles({super.key, required this.rewardModel});
  RewardModel rewardModel;

  final businessController = Get.put(BusinessController(BusinessServices()));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10,left: 12,right: 12),
      child: Container(
        height: 18.h,
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
          clipBehavior: Clip.none,
          alignment: Alignment.topRight,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxHorizontal(width: 10),

                Column(
                  children: [
                    SpacerBoxVertical(height: 1.3.h),
                    Container(
                        height: 14.h,
                        width: 14.h,
                        decoration: BoxDecoration(color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(14.sp),
                          boxShadow: [
                            BoxShadow(color: AppColors.blackColor.withOpacity(0.16),offset: const Offset(0,3),blurRadius: 6.5),
                          ],
                          image: DecorationImage(image: NetworkImage(rewardModel.rewardLogo!),fit: BoxFit.cover),)),
                  ],
                ),

                const SpacerBoxHorizontal(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacerBoxVertical(height: 10),
                      Text(rewardModel.rewardName!, style: poppinsMedium(fontSize: 13.sp),),
                      const SpacerBoxVertical(height: 5),
                      Text(rewardModel.companyName!, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                      const SpacerBoxVertical(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.hintText, size: 12.sp,),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(child: Text(rewardModel.rewardAddress!, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),maxLines: 2,)),
                                const SpacerBoxHorizontal(width: 4),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SpacerBoxVertical(height: 10),
                      Text('${rewardModel.noOfUsed} People Used by now', style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                      const SpacerBoxVertical(height: 10),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 6,
                              width: rewardModel.noOfUsed!.toDouble() * 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: const LinearGradient(
                                  colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ],),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      Get.to(()=> EditMyRewards(rewardModel: rewardModel));
                    }, icon: ImageIcon(const AssetImage(AppAssets.editImg),size: 15.sp,color: AppColors.blackColor)),
                    IconButton(onPressed: (){
                      showAdaptiveDialog(context: context, builder: (context)=> AlertDialog(title: Text('Reward Deletion',style: poppinsMedium(fontSize: 14.sp),),content: const Text('Are you sure you want to delete the reward?'),actions: [
                        TextButton(onPressed: (){
                          Get.back();
                        }, child: const Text('Cancel')),
                        TextButton(onPressed: ()async{
                          await businessController.deleteReward(rewardModel.rewardId!, rewardModel.rewardLogo!).then((value) {
                            Get.back();
                          }
                          );
                        }, child: const Text('Delete')),
                      ],));
                    }, icon: ImageIcon(const AssetImage(AppAssets.deleteImg),size: 15.sp,color: AppColors.redColor)),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(6.sp),
                      child: Text("Uses ${rewardModel.uses}",style: poppinsMedium(fontSize: 12.sp),),
                    ))
              ],
            )
          ],
        ),

                        ),
    );
  }
}