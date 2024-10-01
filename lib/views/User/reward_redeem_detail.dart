import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/congratulation_dialog.dart';
import 'package:swipe_app/widgets/detail_tile.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class RewardRedeemDetail extends StatefulWidget {
  final String? rewardId;
  final String? businessId;
  final String? userId;

  const RewardRedeemDetail(
      {super.key, this.rewardId, this.userId, this.businessId});

  @override
  State<RewardRedeemDetail> createState() => _RewardRedeemDetailState();
}

class _RewardRedeemDetailState extends State<RewardRedeemDetail> {
  final RewardController _rewardController = Get.put(RewardController());
  bool isRedeeming = false; // New state variable

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.rewardId != null) {
        _rewardController.listenToReward(widget.rewardId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacerBoxVertical(height: 20),
                    DetailTile(
                      businessId: widget.businessId,
                      isRedeeming: isRedeeming,
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
                                fontSize: 10.sp, color: AppColors.hintText),
                          ),
                        ],
                      ),
                    ),
                    const SpacerBoxVertical(height: 20),
                    Center(
                      child: Text(
                        TempLanguage.txtPoints,
                        style: poppinsBold(
                            fontSize: 13.sp, color: AppColors.secondaryText),
                      ),
                    ),
                    const SpacerBoxVertical(height: 10),
                    Center(
                      child: Text(
                        '$userPoints/$pointsToRedeem',
                        style: poppinsBold(
                            fontSize: 13.sp, color: AppColors.secondaryText),
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
                                  (MediaQuery.of(context).size.width - 60),
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
                    const SpacerBoxVertical(height: 80),
                    if (userPoints >= pointsToRedeem && !isRedeeming)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ButtonWidget(
                          onSwipe: () async {
                            setState(() {
                              isRedeeming = true;
                            });

                            await _rewardController.updateRewardUsage(
                              widget.rewardId!,
                              widget.userId!,
                            );

                            int remainingUses = 0;

                            if (rewardModel.usedBy
                                    ?.containsKey(widget.userId) ??
                                false) {
                              remainingUses =
                                  (rewardModel.usedBy![widget.userId] ?? 0) + 1;
                            }

                            if (remainingUses == rewardModel.uses) {
                              remainingUses = 0;
                            } else {
                              remainingUses = rewardModel.uses! - remainingUses;
                            }

                            // Show the congratulation dialog
                            showCongratulationDialog(
                              onDone: () {
                                setState(() {
                                  isRedeeming = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationService(
                                      child: BottomBarView(
                                        isUser: getStringAsync(
                                                SharedPrefKey.role) ==
                                            SharedPrefKey.user,
                                      ),
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              message: 'reward',
                            );
                          },
                          text: TempLanguage.btnLblSwipeToRedeem,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (isRedeeming)
              Center(
                child: circularProgressBar(),
              ),
          ],
        );
      }),
    );
  }
}
