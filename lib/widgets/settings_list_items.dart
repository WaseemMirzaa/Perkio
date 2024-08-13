import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';

class SettingsListItems extends StatelessWidget {
    final String path;
  final String text;
  const SettingsListItems({required this.path, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide( width: 1, color: Color(0xFFE9E9E9)))
      ),
      child: Row(children: [
        const SpacerBoxHorizontal(width: 20),
        ImageIcon(AssetImage(path),size: 20.sp,),
        SpacerBoxHorizontal(width: 3.w),
        Text(text, style: poppinsRegular(fontSize: 14.sp),)
      ],
      ),
    );
  }
}

class BalanceTile extends StatelessWidget {
  final String path;
  final String text;
  Function() onAdd;
  BalanceTile({required this.path, required this.text, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide( width: 1, color: Color(0xFFE9E9E9))),
        gradient: LinearGradient(colors: [
          AppColors.gradientStartColor,
          AppColors.gradientEndColor,
        ])
      ),
      child: Row(children: [
        const SpacerBoxHorizontal(width: 20),
        ImageIcon(AssetImage(path),size: 20.sp,color: AppColors.whiteColor,),
        SpacerBoxHorizontal(width: 3.w),
        Text(text, style: poppinsRegular(fontSize: 14.sp,color: AppColors.whiteColor),),
        const Spacer(),

        GestureDetector(onTap: onAdd, child: Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
          decoration: BoxDecoration(
          //     gradient: const LinearGradient(colors: [
          // AppColors.gradientStartColor,
          // AppColors.gradientEndColor,]
            color: AppColors.whiteColor
          ,borderRadius: BorderRadius.circular(2.sp)),child: Row(children: [
          Text('ADD',style: poppinsMedium(fontSize: 10.sp,color: AppColors.blackColor),),
           Icon(Icons.add,color: AppColors.blackColor,size: 14.sp,),
        ],),))
      ],
      ),
    );
  }
}