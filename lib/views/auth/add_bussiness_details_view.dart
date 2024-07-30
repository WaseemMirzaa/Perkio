import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/add_deals_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/common_text_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/custom_container.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class AddBusinessDetailsView extends StatefulWidget {
  const AddBusinessDetailsView({super.key});

  @override
  State<AddBusinessDetailsView> createState() => _AddBusinessDetailsViewState();
}

class _AddBusinessDetailsViewState extends State<AddBusinessDetailsView> {
  final AddDealsController myController = Get.find<AddDealsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Stack(children: [
            CustomShapeContainer(height: 22.h,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerBoxVertical(height: 40),
                  BackButtonWidget(padding: EdgeInsets.zero,),
                  Center(child: Text('Add Business Info', style: poppinsMedium(fontSize: 25),))
                ],
              ),
            ),
          ]),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Business Name', style: poppinsRegular(fontSize: 13),),
                    const SpacerBoxVertical(height: 10),
                    const CommonTextField(text: 'Business Name',),
                    const SpacerBoxVertical(height: 20),
                    Text('Business Address', style: poppinsRegular(fontSize: 13),),
                    const SpacerBoxVertical(height: 10),
                    const CommonTextField(text: 'Business Address',),
                    const SpacerBoxVertical(height: 20),
                    Text('Website', style: poppinsRegular(fontSize: 13),),
                    const SpacerBoxVertical(height: 10),
                    const CommonTextField(text: 'Website',),
                    const SpacerBoxVertical(height: 20),
                    Text('Business ID', style: poppinsRegular(fontSize: 13),),
                    const SpacerBoxVertical(height: 10),
                    const CommonTextField(text: 'Business ID',),
                    const SpacerBoxVertical(height: 20),
            
                    Text('Logo', style: poppinsRegular(fontSize: 13),),
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
                    Text('Business Images', style: poppinsRegular(fontSize: 13),),
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
                    ButtonWidget(onSwipe: (){
                      Navigator.pushNamedAndRemoveUntil(context,AppRoutes.bottomBarView,(route)=>false);
                    }, text: TempLanguage.btnLblSwipeToAdd)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}