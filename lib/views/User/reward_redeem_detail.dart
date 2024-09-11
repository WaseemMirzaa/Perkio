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

  @override
  void initState() {
    super.initState();

    // Ensure the reward fetching happens after the first frame is built
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
          return const Center(child: CircularProgressIndicator());
        }

        final rewardModel = _rewardController.rewardModel.value;

        if (rewardModel == null) {
          return const Center(child: Text("No reward found."));
        }

        // Get the points earned by the user and the points needed to redeem
        final int userPoints = rewardModel.pointsEarned?[widget.userId] ?? 0;
        final int pointsToRedeem = rewardModel.pointsToRedeem ?? 1000;

        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxVertical(height: 20),
                DetailTile(
                  businessId: widget.businessId,
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
                          // Adjust width based on user points and total width minus padding
                          width: (userPoints /
                                  (pointsToRedeem > 0 ? pointsToRedeem : 1)) *
                              (MediaQuery.of(context).size.width -
                                  60), // Subtract 60 for horizontal padding
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

                // Inside RewardRedeemDetail widget

                if (userPoints >= pointsToRedeem)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ButtonWidget(
                      onSwipe: () async {
                        // Get the current number of uses from the rewardModel
                        final int currentUses = rewardModel.uses ?? 0;

                        // Update the reward usage in Firestore
                        await _rewardController.updateRewardUsage(
                          widget.rewardId!,
                          widget.userId!,
                        );

                        // Calculate the remaining uses (subtracting 1)
                        final int remainingUses =
                            currentUses > 0 ? currentUses - 1 : 0;

                        // Show the congratulation dialog with the remaining uses
                        showCongratulationDialog(
                          onDone: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationService(
                                  child: BottomBarView(
                                    isUser:
                                        getStringAsync(SharedPrefKey.role) ==
                                            SharedPrefKey.user,
                                  ),
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          message: 'reward',
                          remainingUses:
                              remainingUses, // Pass the remaining uses here
                        );
                      },
                      text: TempLanguage.btnLblSwipeToRedeem,
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
