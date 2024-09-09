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

class RewardsListItems extends StatefulWidget {
  final RewardModel? reward;
  final String? userId; // Make userId optional

  const RewardsListItems(
      {super.key, this.reward, this.userId}); // Update constructor

  @override
  _RewardsListItemsState createState() => _RewardsListItemsState();
}

class _RewardsListItemsState extends State<RewardsListItems> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    // Handle the case where userId might be null
    isLiked = widget.userId != null &&
        widget.reward != null &&
        widget.reward!.isFavourite != null &&
        widget.reward!.isFavourite!.contains(widget.userId!);
  }

  @override
  Widget build(BuildContext context) {
    double progress = widget.reward != null
        ? widget.reward!.pointsEarned! / widget.reward!.pointsToRedeem!
        : 0.6;

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
                  child: SizedBox(
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
                        '${widget.reward?.pointsToRedeem ?? 1000 - (widget.reward?.pointsEarned ?? 200)} points away',
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
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () async {
                    if (widget.userId != null && widget.reward != null) {
                      await Get.find<RewardController>().toggleLike(
                        widget.reward!,
                        widget.userId!,
                      );
                      setState(() {
                        isLiked = !isLiked;
                      });
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
