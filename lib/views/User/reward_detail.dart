import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/user/scan_screen.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/detail_tile.dart';
import 'package:swipe_app/models/reward_model.dart'; // Import RewardModel

class RewardDetail extends StatefulWidget {
  final RewardModel? reward; // Add an optional reward parameter

  const RewardDetail({super.key, this.reward}); // Update constructor

  @override
  State<RewardDetail> createState() => _RewardDetailState();
}

class _RewardDetailState extends State<RewardDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(AppAssets.imageHeader),
              BackButtonWidget(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerBoxVertical(height: 20),
              // Pass the reward model to DetailTile
              DetailTile(reward: widget.reward),
              const SpacerBoxVertical(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      widget.reward?.rewardAddress ?? TempLanguage.txtLoremIpsumShort,
                      style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),
                    ),
                  ],
                ),
              ),
              const SpacerBoxVertical(height: 20),
              Center(
                child: Text(
                  '${widget.reward?.pointsEarned ?? 0}/${widget.reward?.pointsToRedeem ?? 1000}',
                  style: poppinsBold(fontSize: 13.sp, color: AppColors.secondaryText),
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
                        width: widget.reward != null
                            ? (widget.reward!.pointsEarned! / widget.reward!.pointsToRedeem!) * 220
                            : 0, // Adjust width based on progress
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
                                style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),
                              ),
                              const SpacerBoxHorizontal(width: 20),
                              Text(
                                "\$10", // Use actual logic if needed
                                style: poppinsMedium(fontSize: 10.sp),
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
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScanScreen(),
                      ),
                    );
                  },
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
                        child: Image.asset(AppAssets.scannerImg, scale: 3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
