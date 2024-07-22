import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/business_detail_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/business_detail_tile.dart';
import 'package:skhickens_app/widgets/business_detail_tiles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class BusinessDetail extends StatefulWidget {
  const BusinessDetail({super.key});

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  final BusinessDetailController controller = Get.find<BusinessDetailController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Image.asset(AppAssets.imageHeader),

          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              children: [
                
                SpacerBoxVertical(height: 20),
                BusinessDetailTile(),
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
                                TempLanguage.lblAllDeals,
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
                                TempLanguage.lblOffers,
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
                Expanded(
                  child:ListView(
                    children: [
                      BusinessDetailTiles(),
                      BusinessDetailTiles(),
                      BusinessDetailTiles(),
                      BusinessDetailTiles(),
                      BusinessDetailTiles(),
                    ],
                  )
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}