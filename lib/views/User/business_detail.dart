// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/business_detail_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/business_detail_tile.dart';
import 'package:swipe_app/widgets/business_detail_tiles.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class BusinessDetail extends StatefulWidget {
  final String? businessId;
  final String? businessImage;
  final String? businessRating;
  final String? businessName;
  final GeoPoint? businessLocation;
  final String? businessPhone;
  final String? businessWebsite;
  const BusinessDetail(
      {super.key,
      this.businessId,
      this.businessImage,
      this.businessRating,
      this.businessLocation,
      this.businessPhone,
      this.businessWebsite,
      this.businessName});

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  final BusinessDetailController controller =
      Get.find<BusinessDetailController>();

  @override
  void initState() {
    super.initState();
    if (widget.businessId != null) {
      controller.fetchDeals(widget.businessId!);
      controller.fetchReward(widget.businessId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Obx(
        () {
          if (controller.allDeals.isEmpty && controller.reward.value == null) {
            return const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            );
          }

          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200, // Set height for the image
                child: Image.network(
                  widget.businessImage ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              BackButtonWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Column(
                  children: [
                    const SpacerBoxVertical(height: 20),
                    BusinessDetailTile(
                      businessName: widget.businessName,
                      rating: widget.businessRating,
                      website: widget.businessWebsite,
                      location: widget.businessLocation,
                      phone: widget.businessPhone,
                    ),
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
                                        colors: [
                                          AppColors.gradientStartColor,
                                          AppColors.gradientEndColor
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: controller.selectedIndex.value == 0
                                    ? null
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  TempLanguage.lblAllDeals,
                                  style: poppinsRegular(
                                    fontSize: 9,
                                    color: controller.selectedIndex.value == 0
                                        ? AppColors.whiteColor
                                        : Colors.black,
                                  ),
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
                                        colors: [
                                          AppColors.gradientStartColor,
                                          AppColors.gradientEndColor
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: controller.selectedIndex.value == 1
                                    ? null
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  TempLanguage.lblMyRewards,
                                  style: poppinsRegular(
                                    fontSize: 9,
                                    color: controller.selectedIndex.value == 1
                                        ? AppColors.whiteColor
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        children: controller.selectedIndex.value == 0
                            ? controller.allDeals.isNotEmpty
                                ? controller.allDeals
                                    .map((deal) =>
                                        BusinessDetailTiles(deal: deal))
                                    .toList()
                                : [
                                    Center(
                                      child: Text(
                                        'No deals found',
                                        style: poppinsRegular(
                                          fontSize: 14,
                                          color: AppColors.hintText,
                                        ),
                                      ),
                                    ),
                                  ]
                            : controller.reward.value != null
                                ? controller.reward.value
                                    .map((reward) =>
                                        BusinessDetailTiles(reward: reward))
                                    .toList()
                                : [
                                    Center(
                                      child: Text(
                                        'No offers found',
                                        style: poppinsRegular(
                                          fontSize: 14,
                                          color: AppColors.hintText,
                                        ),
                                      ),
                                    ),
                                  ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
