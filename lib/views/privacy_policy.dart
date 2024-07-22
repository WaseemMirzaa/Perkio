import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SpacerBoxVertical(height: 40),
                    Row(
                      children: [
                        Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 3)
                          )
                        ],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.arrow_back),
                          ),
                          
                      ],
                    ),
                    SpacerBoxVertical(height: 20),
                    Text(TempLanguage.txtPrivacyPolicy, style: poppinsMedium(fontSize: 25),)
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
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