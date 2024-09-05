import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/models/reward_model.dart'; // Assuming this is where your RewardModel is located

class RewardsListItems extends StatelessWidget {
  final RewardModel? reward; // Optional parameter to pass the model

  const RewardsListItems({super.key, this.reward});

  @override
  Widget build(BuildContext context) {
    // Example progress value between 0.0 (0%) and 1.0 (100%)
    double progress =
        reward != null ? reward!.pointsEarned! / reward!.pointsToRedeem! : 0.6;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
      child: Container(
        height: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: AppColors.borderColor),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpacerBoxHorizontal(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: SizedBox(
                height: 100, // Set the desired height
                width: 100, // Set the desired width
                child: (reward?.rewardLogo?.isNotEmpty ?? false)
                    ? Image.network(
                        reward!.rewardLogo!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Handle network image error (e.g., show a placeholder)
                          return Image.asset(AppAssets.restaurantImg1,
                              fit: BoxFit.cover);
                        },
                      )
                    : Image.asset(AppAssets.restaurantImg1, fit: BoxFit.cover),
              ),
            ),
            const SpacerBoxHorizontal(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerBoxVertical(height: 10),
                  Text(
                    reward?.rewardName ?? TempLanguage.txtRewardName,
                    style: poppinsMedium(fontSize: 13.sp),
                  ),
                  const SpacerBoxVertical(height: 5),
                  Text(
                    reward?.companyName ?? TempLanguage.txtRestaurantName,
                    style: poppinsRegular(
                        fontSize: 10.sp, color: AppColors.hintText),
                  ),
                  const SpacerBoxVertical(height: 5),
                  Text(
                    '${reward?.pointsToRedeem ?? 1000 - (reward?.pointsEarned ?? 200)} points away',
                    style: poppinsRegular(
                        fontSize: 10.sp, color: AppColors.hintText),
                  ),
                  const SpacerBoxVertical(height: 10),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 6,
                        width: 120, // Full width representing 100%
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
                        height: 6,
                        width: 120 *
                            progress, // Adjust width based on progress value
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
                    ],
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
