import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/add_deals_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/common_text_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class AddDeals extends StatefulWidget {
  const AddDeals({super.key});

  @override
  State<AddDeals> createState() => _AddDealsState();
}

class _AddDealsState extends State<AddDeals> {
  final AddDealsController myController = Get.find<AddDealsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
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
            Text(TempLanguage.txtDeal, style: poppinsRegular(fontSize: 13),),
            SpacerBoxVertical(height: 10),
            CommonTextField(text: TempLanguage.txtSuperDuper,),
            SpacerBoxVertical(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TempLanguage.txtDealPrice, style: poppinsRegular(fontSize: 13),),
                              SpacerBoxVertical(height: 10),
                              CommonTextField(text: "\$100",),
                    ],
                  ),
                ),
                SpacerBoxHorizontal(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TempLanguage.txtUses, style: poppinsRegular(fontSize: 13),),
                              SpacerBoxVertical(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      myController.decreaseCounter();
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: AppColors.whiteColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 3)
                                                      )
                                                    ]
                                                  ),
                                                  child: Center(
                                                    child: Text('-', style: poppinsRegular(fontSize: 18),)
                                                  ),
                                    ),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Obx((){
                                      return Text( "${myController.counter.value}", style: poppinsRegular(fontSize: 17),);
                                    }),
                                  ),
                                  
                                  GestureDetector(
                                    onTap: (){
                                      myController.increaseCounter();
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: AppColors.whiteColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 3)
                                                      )
                                                    ]
                                                  ),
                                                  child: Center(
                                                      child: Text('+', style: poppinsRegular(fontSize: 18),)
                                                    ),
                                    ),
                                  )
                                ],
                              ),
                    ],
                  ),
                )
              ],
            ),
            SpacerBoxVertical(height: 20),
            Text(TempLanguage.txtDealPrice, style: poppinsRegular(fontSize: 13),),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Stack(
                        children: [
                          Image.asset(AppAssets.mealImg, scale: 3,),
                          Positioned(
                            top: 15,
                            right: 30,
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                    SpacerBoxVertical(height: 10),
                    CommonButton(onSwipe: (){}, text: TempLanguage.btnLblSwipeToAdd)
          ],
        ),
      ),
    );
  }
}