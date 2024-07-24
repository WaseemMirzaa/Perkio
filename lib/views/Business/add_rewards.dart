import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/common_text_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class AddRewards extends StatefulWidget {
  const AddRewards({super.key});

  @override
  State<AddRewards> createState() => _AddRewardsState();
}

class _AddRewardsState extends State<AddRewards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpacerBoxVertical(height: 30),
            Row(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: AppColors.whiteColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset(AppAssets.profileImg, scale: 3,),
                ),
                const SpacerBoxHorizontal(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TempLanguage.txtBusinessName, style: poppinsRegular(fontSize: 14),),
                      Text(TempLanguage.txtLocation, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                    ],
                  ),
                ),
              ],
            ),
            const SpacerBoxVertical(height: 20),
            Center(child: Text(TempLanguage.txtAddDetails, style: poppinsMedium(fontSize: 14),)),
            const SpacerBoxVertical(height: 60),
            Text(TempLanguage.txtDeal, style: poppinsRegular(fontSize: 13),),
            const SpacerBoxVertical(height: 10),
            const CommonTextField(text: TempLanguage.txtSuperDuper,),
            const SpacerBoxVertical(height: 20),
            Text(TempLanguage.txtTotalReceiptPrice, style: poppinsRegular(fontSize: 13),),
            const SpacerBoxVertical(height: 10),
            const CommonTextField(text: '\$100',),
            const SpacerBoxVertical(height: 20),
            Text(TempLanguage.txtDetails, style: poppinsRegular(fontSize: 13),),
            const SpacerBoxVertical(height: 10),
            const CommonTextField(text: TempLanguage.txtDetails,),
            const SpacerBoxVertical(height: 50),
            CommonButton(onSwipe: (){
              Get.back();
            }, text: TempLanguage.btnLblSwipeToAdd)
          ],
        ),
      ),
    );
  }
}