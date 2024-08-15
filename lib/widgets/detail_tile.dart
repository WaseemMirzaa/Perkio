import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/views/User/business_detail.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class DetailTile extends StatelessWidget {
  const DetailTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10,left: 20,right: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpacerBoxVertical(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(TempLanguage.txtBusinessName, style: poppinsMedium(fontSize: 13.sp),),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const BusinessDetail()));
                    },
                    child: Text(TempLanguage.txtViewDeals, style: poppinsMedium(fontSize: 8.sp, color: AppColors.yellowColor),)),
              ],
            ),
            const SpacerBoxVertical(height: 5),
            Row(

              children: [
                Icon(Icons.star_half, color: AppColors.yellowColor, size: 11.sp,),
                const SpacerBoxHorizontal(width: 4),
                Text(TempLanguage.txtRating, style: poppinsRegular(fontSize: 10.sp, color: AppColors.yellowColor),),
              ],
            ),
            const SpacerBoxVertical(height: 5),
            Row(
              children: [
                Icon(Icons.phone, color: AppColors.hintText, size: 11.sp,),
                const SpacerBoxHorizontal(width: 4),
                Text(TempLanguage.txtDummyPhone, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
              ],
            ),
            const SpacerBoxVertical(height: 5),
            Row(
              children: [
                Image.asset(AppAssets.globeImg, scale: 2.5.sp,),
                const SpacerBoxHorizontal(width: 4),
                Text(TempLanguage.txtDummyWebsite, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
              ],
            ),
            const SpacerBoxVertical(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.hintText, size: 11.sp,),
                const SpacerBoxHorizontal(width: 4),
                Text(TempLanguage.txtDummyAddress, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
              ],
            ),
            const SpacerBoxVertical(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 1,
                color: AppColors.blackColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}