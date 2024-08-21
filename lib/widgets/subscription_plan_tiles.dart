import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/common_space.dart';

class gradientTile extends StatelessWidget {
  const gradientTile({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
                  height: 16.5.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [ Color(0xFFFF197C),Color(0xffFFA405)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3)
                      )
                    ]
                  ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppAssets.checkMark, scale: 3,),
                const SpacerBoxHorizontal(width: 10),
                Expanded(child: Text('Get Access to Unlimited Deals and Rewards', style: metropolisExtraBold(fontSize: 14.sp, color: AppColors.whiteColor),))
              ],
            ),
          ),
          const SpacerBoxVertical(height: 10),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(AppAssets.checkMark, scale: 3,),
                                                              const SpacerBoxHorizontal(width: 10),
                                                              Expanded(child: Text("Save Hundreds Each Month", style: metropolisExtraBold(fontSize: 14.sp, color: AppColors.whiteColor),))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                );
  }
}

class PlanTiles extends StatelessWidget {
  final String heading;
  final String price;
  final String desc;
  final Function()? onTap;
  PlanTiles({super.key, required this.heading, required this.price, required this.desc, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
                    height: 17.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 1, color: AppColors.borderColor),
                      color: const Color(0xFFF2F2F2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3)
                        )
                      ]
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        desc.isNotEmpty ? const SizedBox.shrink() : SizedBox(height: 2.h,),

                                        Text(heading, style: metropolisMedium(fontSize: 22.sp,height: 0.6),),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                          Text('\$', style: metropolisRegular(fontSize: 14.sp,),),
                                          Text(price, style: metropolisMedium(fontSize: 36.sp),),
                                        ],),
                                       desc.isNotEmpty ? Text(desc,textAlign: TextAlign.center,style: metropolisRegular(fontSize: 12.sp,height: 1.2),) : const SizedBox.shrink(),
                                      ],
                                    ),
                  ),
    );
  }
}