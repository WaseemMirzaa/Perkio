import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class DetailTile extends StatelessWidget {
  const DetailTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10,left: 12,right: 12),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(width: 1, color: AppColors.borderColor),
          color: AppColors.whiteColor,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.2),
          //     blurRadius: 6,
          //     offset: Offset(0, 3)
          //   )
          // ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpacerBoxVertical(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(TempLanguage.txtBusinessName, style: poppinsMedium(fontSize: 14),),
                  GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.businessDetail);
                      },
                      child: Text(TempLanguage.txtViewRating, style: poppinsMedium(fontSize: 7.sp, color: AppColors.yellowColor),)),
                ],
              ),
              SpacerBoxVertical(height: 5),
              Row(

                children: [
                  Icon(Icons.star_half, color: AppColors.yellowColor, size: 10,),
                  SpacerBoxHorizontal(width: 4),
                  Text(TempLanguage.txtRating, style: poppinsRegular(fontSize: 10, color: AppColors.yellowColor),),
                ],
              ),
              SpacerBoxVertical(height: 5),
              Row(
                children: [
                  Icon(Icons.phone, color: AppColors.hintText, size: 10,),
                  SpacerBoxHorizontal(width: 4),
                  Text(TempLanguage.txtDummyPhone, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                ],
              ),
              SpacerBoxVertical(height: 5),
              Row(
                children: [
                  Image.asset(AppAssets.globeImg, scale: 3,),
                  SpacerBoxHorizontal(width: 4),
                  Text(TempLanguage.txtDummyWebsite, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                ],
              ),
              SpacerBoxVertical(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.hintText, size: 10,),
                  SpacerBoxHorizontal(width: 4),
                  Text(TempLanguage.txtDummyAddress, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                ],
              ),


              SpacerBoxVertical(height: 5),
            ],
          ),
        ),

      ),
    );
  }
}