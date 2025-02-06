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
import 'package:swipe_app/widgets/dialog_box_for_signup.dart';

import '../../core/utils/constants/app_const.dart';
import '../bottom_bar_view/bottom_bar_view.dart';

class DealDetail extends StatefulWidget {
  final DealModel? deal;
  final bool isGuestLogin;

  const DealDetail({super.key, this.deal, this.isGuestLogin = false});

  @override
  State<DealDetail> createState() => _DealDetailState();
}

class _DealDetailState extends State<DealDetail> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double userLat = getDoubleAsync(SharedPrefKey.latitude);
    double userLon = getDoubleAsync(SharedPrefKey.longitude);
    final deal = widget.deal;
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
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return _buildLoadingIndicator();
          // }

          if (snapshot.hasError) {
            return _buildError('Error fetching deal data');
          }

          bool canSwipe = snapshot.data ?? true;

          return Stack(
            children: [
              _buildDealInfo(context, deal, canSwipe, distance),
              if (isLoading)
                _buildLoadingOverlay(), // Overlay with loading spinner
            ],
          );
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DetailTile(
                  businessId: deal.businessId,
                  isGuestLogin: widget.isGuestLogin,
                ),
                const SpacerBoxVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 250.0,
                            child: Text(
                              deal.dealName ?? TempLanguage.txtDealName,
                              style: poppinsMedium(fontSize: 13.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                const SizedBox(
                    height: 20), // Space before the message or button

                // Display message if canSwipe is false
                if (!canSwipe)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "You have reached the maximum limit for redeeming this deal.",
                      style: poppinsRegular(
                        fontSize: 12.sp,
                        color: AppColors.hintText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Button will always be at the bottom
        if (canSwipe)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 20), // Add vertical padding for better spacing
            child: ButtonWidget(
              onSwipe: () async {
                if (widget.isGuestLogin) {
                  LoginRequiredDialog.show(context, true);
                  return;
                }

                setState(() {
                  isLoading = true; // Start loading
                });

                await controller.updateUsedBy(deal.dealId!);

                setState(() {
                  isLoading = false; // Stop loading
                });

                showCongratulationDialog(
                  onDone: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationService(
                          child: BottomBarView(
                            isUser: true,
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
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Stack(
      children: [
        // This prevents interaction with the screen behind and adds a transparent barrier.
        AbsorbPointer(
          absorbing: true, // Prevent interactions behind the loading indicator
          child: ModalBarrier(
            color: Colors.black.withOpacity(0.5), // Dimming effect
          ),
        ),
        // Show the loading spinner at the center
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.gradientStartColor,
          ),
        ),
      ],
    );
  }
}
