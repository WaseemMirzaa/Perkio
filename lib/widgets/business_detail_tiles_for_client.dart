import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/widgets/common/common_widgets.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class BusinessDetailTilesforClientSide extends StatelessWidget {
  final DealModel? deal; // Optional deal parameter
  final RewardModel? reward; // Optional reward parameter

  const BusinessDetailTilesforClientSide({super.key, this.deal, this.reward});

  @override
  Widget build(BuildContext context) {
    final image = reward?.rewardLogo ?? deal?.image;
    final dealName = reward?.rewardName ?? deal?.dealName;
    final companyName = reward?.companyName ?? deal?.companyName;
    final uses = reward?.uses ?? deal?.uses ?? 0;

    // Calculate distance if it's a deal
    String distanceText = '';
    if (deal != null && deal!.location != null) {
      double userLat = getDoubleAsync(SharedPrefKey.latitude);
      double userLon = getDoubleAsync(SharedPrefKey.longitude);

      final distance = calculateDistance(
        userLat,
        userLon,
        deal!.longLat!.latitude,
        deal!.longLat!.longitude,
      );
      distanceText =
          '${distance.toStringAsFixed(1)} miles'; // Display distance in km
    }

    return Container(
      height: 130,
      margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
      padding: const EdgeInsets.all(2),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  SpacerBoxVertical(height: 1.3.h),
                  SizedBox(
                    height: 100, // Set a fixed height
                    width: 100, // Set a fixed width
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          14), // Set the radius to half the height/width for circular shape
                      child: image != null
                          ? Image.network(
                              image,
                              fit: BoxFit.cover, // Ensure image covers the box
                            )
                          : Image.asset(
                              AppAssets.restaurantImg1,
                              fit: BoxFit.cover, // Ensure image covers the box
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SpacerBoxHorizontal(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxVertical(height: 10),
                Text(
                  dealName ?? TempLanguage.txtDealName,
                  style: poppinsMedium(fontSize: 14),
                ),
                const SpacerBoxVertical(height: 5),
                Text(
                  companyName ?? TempLanguage.txtRestaurantName,
                  style:
                      poppinsRegular(fontSize: 12, color: AppColors.hintText),
                ),
                const SpacerBoxVertical(height: 5),
                if (deal != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.hintText,
                        size: 12.sp,
                      ),
                      Expanded(
                        child: Text(
                          distanceText, // Display calculated distance
                          style: poppinsRegular(
                              fontSize: 12, color: AppColors.hintText),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                if (reward != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.hintText,
                        size: 12.sp,
                      ),
                      Expanded(
                        child: Text(
                          reward!.rewardAddress!,
                          style: poppinsRegular(
                              fontSize: 12, color: AppColors.hintText),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                const SpacerBoxVertical(height: 10),
                const SizedBox(
                  height: 15,
                  width: 40,
                ),
                Text(
                  'USES $uses', // Display the number of uses
                  style: poppinsMedium(fontSize: 13.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
