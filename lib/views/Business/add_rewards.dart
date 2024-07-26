import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/common_text_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/custom_appBar/custom_appBar.dart';

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
      appBar: PreferredSize(preferredSize: Size.fromHeight(12.h),child: customAppBar(),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ButtonWidget(onSwipe: (){
              Get.back();
            }, text: TempLanguage.btnLblSwipeToAdd)
          ],
        ),
      ),
    );
  }
}