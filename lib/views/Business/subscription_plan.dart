import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/routes/app_routes.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';
import 'package:swipe_app/widgets/subscription_plan_tiles.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class SubscriptionPlan extends StatefulWidget {
  SubscriptionPlan({super.key, this.fromSignUp = false});
  bool fromSignUp;
  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

class _SubscriptionPlanState extends State<SubscriptionPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomShapeContainer(height: 21.h,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacerBoxVertical(height: 40),
                    BackButtonWidget(padding: EdgeInsets.zero,),
                    Center(child: Text(TempLanguage.txtSubscriptionPlan, style: poppinsMedium(fontSize: 25),))
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(TempLanguage.txtChooseAPlan, style: poppinsMedium(fontSize: 18),),
          ),
          Expanded(child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
            children: [
              const gradientTile(),
              const SpacerBoxVertical(height: 20),
              PlanTiles(heading: TempLanguage.txtMonthly, price: '4.99', desc: TempLanguage.txtPerfectForStarters,onTap: (){
                widget.fromSignUp ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false)),(route)=>false) : Navigator.pop(context);
              },),
              const SpacerBoxVertical(height: 20),
               PlanTiles(heading: TempLanguage.txtYearly, price: '45', desc: TempLanguage.txtSave24,onTap: (){
                widget.fromSignUp ?  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false)),(route)=>false) : Get.back();
              },

              ),
            ],
          ))
        ],
      ),
    );
  }
}