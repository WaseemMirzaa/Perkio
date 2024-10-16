import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/views/user/reward_redeem_detail.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/detail_tile.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:get/get.dart';

class RewardDetail extends StatefulWidget {
  final RewardModel? reward;
  final String? userId;
  final bool isNavigationFromNotifications;

  const RewardDetail(
      {super.key,
      this.reward,
      this.userId,
      this.isNavigationFromNotifications = false});

  @override
  State<RewardDetail> createState() => _RewardDetailState();
}

class _RewardDetailState extends State<RewardDetail> {
  final RewardController rewardController = Get.put(RewardController());

  @override
  void initState() {
    super.initState();

    log('💥💥💥💥💥💥💥💥${widget.isNavigationFromNotifications}');

    if (!widget.isNavigationFromNotifications) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final pointsEarned = widget.reward?.pointsEarned?[widget.userId] ?? 0;
        final pointsToRedeem = widget.reward?.pointsToRedeem ?? 0;

        if (pointsEarned >= pointsToRedeem) {
          Get.offAll(() => RewardRedeemDetail(
                rewardId: widget.reward?.rewardId,
                businessId: widget.reward?.businessId,
                userId: widget.userId,
              ));
        }
      });
    }
  }

  Future<void> _pickImageAndUpload() async {
    await Future.delayed(
        const Duration(milliseconds: 200)); // Give the UI time to update
    final status = await Permission.camera.request();

    if (status.isGranted) {
      rewardController.isLoadingforscan.value = true;

      print('💥💥💥💥💥💥💥💥💥💥 ${widget.reward!.rewardId} ');
      print('💥💥💥💥💥💥💥💥💥💥 ${widget.userId} ');

      await rewardController.pickImageAndUpload(
        widget.reward!,
        widget.userId!,
      );
    } else if (status.isDenied || status.isPermanentlyDenied) {
      _showPermissionDialog(context);
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera Permission'),
          content:
              const Text('Please allow camera permission to scan the receipt.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                final status = await Permission.camera
                    .request(); // Request permission again

                if (status.isGranted) {
                  _pickImageAndUpload(); // Try picking the image again
                } else if (status.isPermanentlyDenied) {
                  openAppSettings(); // If permanently denied, redirect to settings
                }
              },
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pointsEarned = widget.reward?.pointsEarned?[widget.userId] ?? 0;
    final pointsToRedeem = widget.reward?.pointsToRedeem ?? 0;
    final remainingPoints = pointsToRedeem - pointsEarned;
    final int userUses = widget.reward?.usedBy?[widget.userId] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailTile(
                businessId: widget.reward?.businessId,
              ),
              const SpacerBoxVertical(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reward?.rewardName ?? TempLanguage.txtRewardInfo,
                      style: poppinsMedium(fontSize: 13.sp),
                    ),
                    const SpacerBoxVertical(height: 10),
                    Text(
                      widget.reward?.rewardAddress ??
                          TempLanguage.txtLoremIpsumShort,
                      style: poppinsRegular(
                          fontSize: 10.sp, color: AppColors.hintText),
                    ),
                  ],
                ),
              ),
              const SpacerBoxVertical(height: 50),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Points',
                      style: poppinsBold(
                          fontSize: 12.sp, color: AppColors.hintText),
                    ),
                    Text(
                      '$pointsEarned/$pointsToRedeem',
                      style: poppinsBold(
                          fontSize: 13.sp, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              const SpacerBoxVertical(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  height: 45,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey[200],
                        ),
                      ),
                      Container(
                        height: 20,
                        width: (pointsToRedeem > 0)
                            ? (pointsEarned / pointsToRedeem) *
                                (MediaQuery.of(context).size.width - 60)
                            : 0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gradientStartColor,
                              AppColors.gradientEndColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: -1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                TempLanguage.txtSpendMore,
                                style: poppinsRegular(
                                    fontSize: 10.sp, color: AppColors.hintText),
                              ),
                              const SpacerBoxHorizontal(width: 20),
                              Text(
                                "$remainingPoints points",
                                style: poppinsMedium(fontSize: 8.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SpacerBoxVertical(height: 40),
              FutureBuilder<bool>(
                future: rewardController.canSwipe(widget.reward!.rewardId!),
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return _buildLoadingIndicator();
                  // }

                  bool canSwipe = snapshot.data ?? true;

                  return canSwipe
                      ? Center(
                          child: GestureDetector(
                            onTap: rewardController.isLoadingforscan.value
                                ? null
                                : _pickImageAndUpload, // Prevent tapping during processing
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 12,
                                    spreadRadius: 6,
                                    offset: const Offset(5, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.gradientStartColor,
                                        AppColors.gradientEndColor,
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Image.asset(AppAssets.scannerImg,
                                      scale: 3),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "You have used this reward the maximum allowed times.",
                            style: poppinsRegular(
                                fontSize: 12.sp, color: AppColors.hintText),
                            textAlign: TextAlign.center,
                          ),
                        );
                },
              ),
            ],
          ),
          Obx(() => rewardController.isLoadingforscan.value
              ? Container(
                  color: Colors.black54, // Dark overlay
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.gradientEndColor,
                      strokeWidth: 5.0,
                    ),
                  ),
                )
              : const SizedBox()), // Placeholder when not loading
        ],
      ),
    );
  }
}
