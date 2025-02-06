import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/user/reward_list_confirmation.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/detail_tile.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class RewardRedeemDetail extends StatefulWidget {
  final String? rewardId;
  final String? businessId;
  final String? userId;
  final bool isNavigationFromNotifications;
  final bool isNormalRouting;

  const RewardRedeemDetail(
      {super.key,
      this.rewardId,
      this.userId,
      this.isNormalRouting = false,
      this.businessId,
      this.isNavigationFromNotifications = false});

  @override
  State<RewardRedeemDetail> createState() => _RewardRedeemDetailState();
}

class _RewardRedeemDetailState extends State<RewardRedeemDetail> {
  final RewardController _rewardController = Get.put(RewardController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.rewardId != null) {
        _rewardController.listenToReward(widget.rewardId!);
      }
    });
  }

  Future<bool> _onWillPop() async {
    Get.offAll(() => const BottomBarView(
          isUser: true,
        ));
    return false; // Prevent the default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Obx(() {
          if (_rewardController.isLoading.value) {
            return Center(child: circularProgressBar());
          }

          final rewardModel = _rewardController.rewardModel.value;

          if (rewardModel == null) {
            return const Center(child: Text("No reward found."));
          }

          final int userPoints = rewardModel.pointsEarned?[widget.userId] ?? 0;
          final int pointsToRedeem = rewardModel.pointsToRedeem ?? 1000;

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailTile(
                            businessId: widget.businessId,
                            isNormalRouting: true,
                          ),
                          const SpacerBoxVertical(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  TempLanguage.txtRewardInfo,
                                  style: poppinsMedium(fontSize: 13.sp),
                                ),
                                const SpacerBoxVertical(height: 10),
                                Text(
                                  rewardModel.rewardName ??
                                      TempLanguage.txtLoremIpsumShort,
                                  style: poppinsRegular(
                                      fontSize: 10.sp,
                                      color: AppColors.hintText),
                                ),
                              ],
                            ),
                          ),
                          const SpacerBoxVertical(height: 20),
                          Center(
                            child: Text(
                              TempLanguage.txtPoints,
                              style: poppinsBold(
                                  fontSize: 13.sp,
                                  color: AppColors.secondaryText),
                            ),
                          ),
                          const SpacerBoxVertical(height: 10),
                          userPoints > pointsToRedeem ?
                          Center(
                            child: Text(
                              '$pointsToRedeem/$pointsToRedeem',
                              style: poppinsBold(
                                  fontSize: 13.sp,
                                  color: AppColors.secondaryText),
                            ),
                          ) 
                          :
                          Center(
                            child: Text(
                              '$userPoints/$pointsToRedeem',
                              style: poppinsBold(
                                  fontSize: 13.sp,
                                  color: AppColors.secondaryText),
                            ),
                          ) 
                          
                          ,
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
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: (userPoints /
                                            (pointsToRedeem > 0
                                                ? pointsToRedeem
                                                : 1)) *
                                        (MediaQuery.of(context).size.width -
                                            60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.gradientStartColor,
                                          AppColors.gradientEndColor
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // Space before the button
                        ],
                      ),
                    ),
                  ),
                  // Button will always be at the bottom
                  if (userPoints >= pointsToRedeem)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical:
                              20), // Add vertical padding for better spacing
                      child: ButtonWidget(
                        onSwipe: () async {
                          await _rewardController.fetchReceipts(
                            rewardModel.rewardId!,
                          );

                          // Navigate to ConfirmRewardRedeemList
                          List<dynamic> images = _rewardController.userReceipts
                              .expand((receipt) => receipt.imageUrls ?? [])
                              .toList();

                          Get.to(() => ConfirmRewardRedeemList(
                                rewardId: rewardModel.rewardId!,
                                userId: widget.userId!,
                                businessName: rewardModel.companyName!,
                                rewardName: rewardModel.rewardName!,
                                rewardImages: [...images],
                              ));
                        },
                        text: TempLanguage.btnLblSwipeToClaim,
                      ),
                    ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
