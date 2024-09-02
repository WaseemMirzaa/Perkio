import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/business_detail_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/Business/add_deals.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/business_detail_tile.dart';
import 'package:swipe_app/widgets/business_detail_tiles.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

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
      body: Obx(()=> Stack(
          children: [
            Image.asset(AppAssets.imageHeader),
            BackButtonWidget(),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [

                  const SpacerBoxVertical(height: 20),
                  const BusinessDetailTile(),
                  const SpacerBoxVertical(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () => controller.selectIndex(0),
                            child: Container(
                              height: 30,
                              width: 90,
                              decoration: BoxDecoration(
                                gradient: controller.selectedIndex.value == 0
                                    ? const LinearGradient(
                                        colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
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

                        const SpacerBoxHorizontal(width: 10),
                         GestureDetector(
                            onTap: () => controller.selectIndex(1),
                            child: Container(
                              height: 30,
                              width: 90,
                              decoration: BoxDecoration(
                                gradient: controller.selectedIndex.value == 1
                                    ? const LinearGradient(
                                        colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
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
                      ],
                    ),
                  ),
                  Expanded(
                    child:GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddDeals()));
                      },
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        children: const [
                          BusinessDetailTiles(),
                          BusinessDetailTiles(),
                          BusinessDetailTiles(),
                          BusinessDetailTiles(),
                          BusinessDetailTiles(),
                        ],
                      ),
                    )
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}