// Import to use math functions

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/business_detail_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common/common_widgets.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/congratulation_dialog.dart';
import 'package:swipe_app/widgets/detail_tile.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

import '../../core/utils/constants/app_const.dart';
import '../bottom_bar_view/bottom_bar_view.dart';

class DealDetail extends StatelessWidget {
  final DealModel? deal;

  const DealDetail({super.key, this.deal});

  @override
  Widget build(BuildContext context) {
    double userLat = getDoubleAsync(SharedPrefKey.latitude);
    double userLon = getDoubleAsync(SharedPrefKey.longitude);
    final deal = this.deal;
    final controller = Get.find<BusinessDetailController>();

    if (deal == null) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: _buildError('Deal not found'),
      );
    }

    // Calculate distance if deal location is available
    double distance = 0;
    if (deal.longLat != null) {
      distance = calculateDistance(
        userLat,
        userLon,
        deal.longLat!.latitude,
        deal.longLat!.longitude,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: FutureBuilder<bool>(
        future: controller.canSwipe(deal.dealId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          }

          if (snapshot.hasError) {
            return _buildError('Error fetching deal data');
          }

          bool canSwipe = snapshot.data ?? true;

          return _buildDealInfo(context, deal, canSwipe, distance);
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: circularProgressBar(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        message,
        style: poppinsMedium(fontSize: 14),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: 200, // Set the desired fixed height here
        child: Image.network(
          imageUrl ?? AppAssets.foodImg,
          scale: 3,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.gradientStartColor,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(AppAssets.foodImg, scale: 3);
          },
        ),
      ),
    );
  }

  Widget _buildDealInfo(
      BuildContext context, DealModel deal, bool canSwipe, double distance) {
    final controller = Get.find<BusinessDetailController>();

    return Column(
      children: [
        const SpacerBoxVertical(height: 36),
        DetailTile(businessId: deal.businessId),
        const SpacerBoxVertical(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.dealName ?? TempLanguage.txtDealName,
                    style: poppinsMedium(fontSize: 13.sp),
                  ),
                  Text(
                    '${distance.toStringAsFixed(2)} miles', // Display distance
                    style: poppinsRegular(
                      fontSize: 10.sp,
                      color: AppColors.hintText,
                    ),
                  ),
                ],
              ),
              Text(
                'USES ${deal.uses}',
                style: poppinsMedium(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SpacerBoxVertical(height: 20),
        _buildImage(deal.image),
        const SpacerBoxVertical(height: 20),
        if (canSwipe)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ButtonWidget(
              onSwipe: () async {
                await controller.updateUsedBy(deal.dealId!);

                Map<String, dynamic> dealData =
                    await controller.fetchDealData(deal.dealId!);
                Map<String, int> usedBy =
                    Map<String, int>.from(dealData['usedBy'] ?? {});
                int userCurrentUsage =
                    usedBy[controller.currentUserId ?? ''] ?? 0;
                int remainingUses = deal.uses! - userCurrentUsage - 1;

                showCongratulationDialog(
                  onDone: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationService(
                          child: BottomBarView(
                            isUser: getStringAsync(SharedPrefKey.role) ==
                                SharedPrefKey.user,
                          ),
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  message: 'deal',
                );
              },
              text: TempLanguage.btnLblSwipeToRedeem,
            ),
          ),
        if (!canSwipe)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "You have used this deal the maximum allowed times.",
              style: poppinsRegular(
                fontSize: 12.sp,
                color: AppColors.hintText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
