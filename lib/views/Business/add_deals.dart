import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/add_deals_controller.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/common_text_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class AddDeals extends StatefulWidget {
  const AddDeals({super.key});

  @override
  State<AddDeals> createState() => _AddDealsState();
}

class _AddDealsState extends State<AddDeals> {
  final AddDealsController myController = Get.find<AddDealsController>();
  final BusinessController controller = Get.find<BusinessController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(12.h),child: customAppBar(),),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerBoxVertical(height: 20),
              Center(child: Text(TempLanguage.txtAddDetails, style: poppinsMedium(fontSize: 14),)),
              const SpacerBoxVertical(height: 60),
              Text(TempLanguage.txtDeal, style: poppinsRegular(fontSize: 13),),
              const SpacerBoxVertical(height: 10),
              CommonTextField(text: TempLanguage.txtSuperDuper,textController: myController.dealNameController,),
              const SpacerBoxVertical(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TempLanguage.txtUses, style: poppinsRegular(fontSize: 13),),
                                const SpacerBoxVertical(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                                          offset: const Offset(0, 3)
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
                                                          offset: const Offset(0, 3)
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
              const SpacerBoxVertical(height: 20),
              Text(TempLanguage.txtDealPrice, style: poppinsRegular(fontSize: 13),),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Stack(
                          children: [
                            Image.asset(AppAssets.mealImg, scale: 3,),
                            const Positioned(
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
                      const SpacerBoxVertical(height: 10),
              Obx(()=> controller.loading.value
                  ? Center(child: const CircularProgressIndicator())
                  : ButtonWidget(onSwipe: (){
                controller.addDeal(myController.dealNameController.text, myController.dealPriceController.text, myController.counter.value.toString());
              }, text: TempLanguage.btnLblSwipeToAdd),),
            ],
          ),
        ),
      ),
    );
  }
}