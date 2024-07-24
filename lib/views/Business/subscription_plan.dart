import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/subscription_plan_tiles.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

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
              CustomShapeContainer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpacerBoxVertical(height: 40),
                    BackButtonWidget(padding: EdgeInsets.zero,),
                    SpacerBoxVertical(height: 20),
                    Text(TempLanguage.txtSubscriptionPlan, style: poppinsMedium(fontSize: 25),)
                  ],
                ),
              ),
            ],
          ),
          SpacerBoxVertical(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(TempLanguage.txtChooseAPlan, style: poppinsMedium(fontSize: 18),),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              children: [
                gradientTile(),
                SpacerBoxVertical(height: 20),
                PlanTiles(heading: TempLanguage.txtMonthly, price: '4.99', desc: TempLanguage.txtPerfectForStarters),
                SpacerBoxVertical(height: 20),
                PlanTiles(heading: TempLanguage.txtYearly, price: '45', desc: TempLanguage.txtSave24),
              ],
            ),
          ))
        ],
      ),
    );
  }
}