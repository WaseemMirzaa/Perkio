import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/models/reward_model.dart'; // Assuming this is where your RewardModel is located

class MyRewardsListItems extends StatefulWidget {
  final RewardModel? reward;
  final String? userId;

  const MyRewardsListItems({
    super.key,
    this.reward,
    this.userId,
  });

  @override
  _MyRewardsListItemsState createState() => _MyRewardsListItemsState();
}

class _MyRewardsListItemsState extends State<MyRewardsListItems> {
  RxBool isFav = true.obs;
  final RewardController rewardController = Get.find<RewardController>();

  @override
  void initState() {
    super.initState();
    // Initialize the isFav observable based on the reward's favorite status, using the cache
    if (widget.userId != null && widget.reward != null) {
      isFav.value =
          rewardController.isRewardLiked(widget.reward!, widget.userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure pointsEarned from the Map<String, int> using the userId is updated dynamically
    int pointsEarnedByUser = (widget.userId != null &&
            widget.reward != null &&
            widget.reward!.pointsEarned != null)
        ? (widget.reward!.pointsEarned![widget.userId!] ?? 0)
        : 0;

    // Ensure pointsToRedeem and pointsEarned are not null and prevent divide by 0
    double progress = widget.reward != null &&
            widget.reward!.pointsToRedeem != null &&
            widget.reward!.pointsToRedeem! > 0
        ? pointsEarnedByUser / widget.reward!.pointsToRedeem!
        : 0.0;

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
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxHorizontal(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.sp),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: (widget.reward?.rewardLogo?.isNotEmpty ?? false)
                          ? Image.network(
                              widget.reward!.rewardLogo!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(AppAssets.restaurantImg1,
                                    fit: BoxFit.cover);
                              },
                            )
                          : Image.asset(AppAssets.restaurantImg1,
                              fit: BoxFit.cover),
                    ),
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
                        widget.reward?.rewardName ?? TempLanguage.txtRewardName,
                        style: poppinsMedium(fontSize: 13.sp),
                      ),
                      const SpacerBoxVertical(height: 5),
                      Text(
                        widget.reward?.companyName ??
                            TempLanguage.txtRestaurantName,
                        style: poppinsRegular(
                            fontSize: 10.sp, color: AppColors.hintText),
                      ),
                      const SpacerBoxVertical(height: 5),
                      Text(
                        widget.reward != null &&
                                widget.reward!.pointsToRedeem != null
                            ? '${(widget.reward!.pointsToRedeem! - pointsEarnedByUser).clamp(0, widget.reward!.pointsToRedeem!)} points away'
                            : '1000 points away',
                        style: poppinsRegular(
                            fontSize: 10.sp, color: AppColors.hintText),
                      ),
                      const SpacerBoxVertical(height: 10),
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            height: 6,
                            width: 120,
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
                            width: 120 * progress,
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
            if (widget.userId !=
                null) // Show like button only if userId is provided
              Positioned(
                top: 5,
                right: 5,
                child: Obx(() => IconButton(
                      icon: Image.asset(
                        isFav.value
                            ? AppAssets.likeFilledImg
                            : AppAssets.likeImg,
                        width: 12.sp,
                        height: 12.sp,
                      ),
                      iconSize: 12.sp, // Set the icon size here
                      onPressed: () async {
                        if (widget.userId != null && widget.reward != null) {
                          await rewardController.toggleLike(
                            widget.reward!,
                            widget.userId!,
                          );
                          // Toggle isFav value after the action completes using the cache
                          isFav.value = rewardController.isRewardLiked(
                              widget.reward!, widget.userId!);
                        }
                      },
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
