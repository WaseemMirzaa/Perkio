import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/add_rewards_controller.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
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
  final AddRewardsController myController = Get.find<AddRewardsController>();
  final BusinessController controller = Get.find<BusinessController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerBoxVertical(height: 30),
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
                  SpacerBoxHorizontal(width: 10),
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
              SpacerBoxVertical(height: 20),
              Center(child: Text(TempLanguage.txtAddDetails, style: poppinsMedium(fontSize: 14),)),
              SpacerBoxVertical(height: 60),
              Text(TempLanguage.txtDeal, style: poppinsRegular(fontSize: 13)),
              SpacerBoxVertical(height: 10),
              CommonTextField(text: TempLanguage.txtSuperDuper, textController: myController.dealNameController,),
              SpacerBoxVertical(height: 20),
              Text(TempLanguage.txtTotalReceiptPrice, style: poppinsRegular(fontSize: 13),),
              SpacerBoxVertical(height: 10),
              CommonTextField(text: '\$100', textController: myController.receiptPriceController,),
              SpacerBoxVertical(height: 20),
              Text(TempLanguage.txtDetails, style: poppinsRegular(fontSize: 13),),
              SpacerBoxVertical(height: 10),
              CommonTextField(text: TempLanguage.txtDetails, textController: myController.detailsController,),
              SpacerBoxVertical(height: 50),
              Obx(()=> controller.loading.value
                        ? Center(child: const CircularProgressIndicator())
                        : CommonButton(onSwipe: (){
                          controller.addDeal(myController.dealNameController.text, myController.receiptPriceController.text, myController.detailsController.text);
                        }, text: TempLanguage.btnLblSwipeToAdd))
            ],
          ),
        ),
      ),
    );
  }
}