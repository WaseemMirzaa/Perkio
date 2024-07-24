import 'package:flutter/material.dart';
import 'package:get/get.dart';
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


class FavouritesScreen extends StatelessWidget {
  final FavouritesScreenController controller = Get.find<FavouritesScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Stack(
            children: [
              CustomShapeContainer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
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
                              Text(TempLanguage.txtSkhickens, style: poppinsRegular(fontSize: 14),),
                              Text(TempLanguage.txtLocation, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                            ],
                          ),
                        ),
                        Image.asset(AppAssets.notificationImg, scale: 3,)
                      ],
                    ),
                    SpacerBoxVertical(height: 20),
                    SearchField(),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(TempLanguage.txtYourFavorite, style: poppinsMedium(fontSize: 18),),
                ),
                SpacerBoxVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Obx(() => GestureDetector(
                          onTap: () => controller.selectIndex(0),
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              gradient: controller.selectedIndex.value == 0
                                  ? LinearGradient(
                                      colors: [Colors.red, Colors.orange],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: controller.selectedIndex.value == 0 ? null : Colors.grey[200],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                TempLanguage.lblMyDeals,
                                style: poppinsRegular(fontSize: 9, color: controller.selectedIndex.value == 0
                                      ? AppColors.whiteColor
                                      : Colors.black,),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SpacerBoxHorizontal(width: 10),
                      Obx(() => GestureDetector(
                          onTap: () => controller.selectIndex(1),
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              gradient: controller.selectedIndex.value == 1
                                  ? LinearGradient(
                                      colors: [Colors.red, Colors.orange],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: controller.selectedIndex.value == 1 ? null : Colors.grey[200],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                TempLanguage.lblMyRewards,
                                style: poppinsRegular(fontSize: 9, color: controller.selectedIndex.value == 1
                                      ? AppColors.whiteColor
                                      : Colors.black,),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Obx((){
                  return Expanded(
                  child: controller.selectedIndex.value == 0 ?ListView(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(AppRoutes.dealDetail);
                        },
                        child: FavouritesWidget()),
                      FavouritesWidget(),
                      FavouritesWidget(),
                      FavouritesWidget(),
                      FavouritesWidget(),
                    ],
                  ) : ListView(
                    children: [
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                    ],
                  ),
                );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
