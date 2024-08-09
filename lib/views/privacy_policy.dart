import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 BackButtonWidget(),
                  SpacerBoxVertical(height: 1.h),
                  Center(child: Text(TempLanguage.txtPrivacyPolicy, style: poppinsMedium(fontSize: 25),))
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(TempLanguage.txtLoremIpsum, style: poppinsRegular(fontSize: 15),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}