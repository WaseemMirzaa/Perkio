import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/services/business_services.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class BusinessHomeListItems extends StatelessWidget {
  BusinessHomeListItems({super.key, required this.dealModel});
  DealModel dealModel;
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
                                    alignment: Alignment.topRight,
                                    children: [
                                      Row(
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
                                                Image.network(dealModel.image!,fit: BoxFit.cover,height: 15.h,width: 22.w,),
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
                                              Text(dealModel.dealName ?? '', style: poppinsMedium(fontSize: 13.sp),),
                                              const SpacerBoxVertical(height: 5),
                                              Text(dealModel.restaurantName ?? '', style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                                              const SpacerBoxVertical(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on, color: AppColors.hintText, size: 12.sp,),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(child: Text(dealModel.location ?? "", style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),maxLines: 2,)),
                                                        const SpacerBoxHorizontal(width: 4),

                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                                const SpacerBoxVertical(height: 5),

                                                Text('${dealModel.uses} People used by now', style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText,),maxLines: 1,),

                                                const Expanded(child: SizedBox()),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: Text("Uses ${dealModel.uses}",style: poppinsMedium(fontSize: 13.sp),),
                                              ),
                                              const SpacerBoxVertical(height: 5),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(onPressed: (){}, icon: ImageIcon(const AssetImage(AppAssets.editImg),size: 15.sp,color: AppColors.blackColor)),
                                              IconButton(onPressed: (){
                                                showAdaptiveDialog(context: context, builder: (context)=> AlertDialog(title: Text('Deal Deletion',style: poppinsMedium(fontSize: 14.sp),),content: const Text('Are you sure you want to delete this deal?'),actions: [
                                                  TextButton(onPressed: (){}, child: const Text('Cancel')),
                                                  TextButton(onPressed: ()async{
                                                   await businessController.deleteDeal(dealModel.dealId!, dealModel.image!).then((value)=>Get.back());
                                                  }, child: const Text('Delete')),
                                                ],));
                                              }, icon: ImageIcon(const AssetImage(AppAssets.deleteImg),size: 15.sp,color: AppColors.redColor)),
                                            ],
                                          ),

                                          Container(
                                            height: 20,
                                            width: 55,
                                            margin: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: Center(child: Text(TempLanguage.txtPromote, style: poppinsRegular(fontSize: 9, color: AppColors.whiteColor),)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  
                        ),
    );
  }
}