import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/controllers/favourites_screen_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/available_list_items.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/favourites_widget.dart';
import 'package:skhickens_app/widgets/rewards_list_items.dart';
import 'package:skhickens_app/widgets/search_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';


class RewardsView extends StatelessWidget {

  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Stack(
            children: [
              CustomShapeContainer(height: 15.h,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
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
                              Text('Skhicken', style: poppinsRegular(fontSize: 14),),
                              Text(TempLanguage.txtLocation, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: (){
                              Get.toNamed(AppRoutes.notifications);
                            },
                            child: Image.asset(AppAssets.notificationImg, scale: 3,))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(TempLanguage.txtRewards, style: poppinsMedium(fontSize: 18),),
                ),
                Expanded(child:GestureDetector(
                  onTap: (){
                    Get.toNamed(AppRoutes.rewardDetail);
                  },
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: const [
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                    ],
                  ),
                ), )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
