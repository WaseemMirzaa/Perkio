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

class ConfirmRewardRedeemList extends StatelessWidget {
  final String businessName;
  final String rewardId;
  final String rewardName;
  final List<String> rewardImages; // Declare the images variable

  const ConfirmRewardRedeemList(
      {super.key,
      required this.businessName,
      required this.rewardName,
      required this.rewardImages,
      required this.rewardId});

  @override
  Widget build(BuildContext context) {
    final RewardController rewardController = Get.find<RewardController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Redeem", style: poppinsBold(fontSize: 14.sp)),
        backgroundColor: AppColors.whiteColor,
      ),
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: rewardImages.length,
              padding: const EdgeInsets.only(bottom: 80), // Adds bottom padding
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the full-screen image view with Hero transition
                    Get.to(() => FullScreenImageView(
                          imagePath: rewardImages[index],
                          tag: 'imageHero-$index',
                        ));
                  },
                  child: RewardItemCard(
                    imagePath: rewardImages[index],
                    businessName: businessName,
                    rewardName: rewardName,
                    heroTag: 'imageHero-$index',
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0, // Fixed at the bottom of the screen
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: ButtonWidget(
                onSwipe: () async {
                  await rewardController.updateReceiptStatus(
                    
                    rewardId,
                  );
                  // Logic to swipe to redeem
                  // Show the congratulation dialog
                  showCongratulationDialog(
                    isPendingforVerification: true,
                    onDone: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationService(
                            child: BottomBarView(
                              isUser: getStringAsync(SharedPrefKey.role) ==
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
                text: "Swipe to Redeem",
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showConfirmRedeemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Redemption"),
          content: const Text("Are you sure you want to redeem this reward?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Call redeem function
                Navigator.pop(context);
                Get.snackbar("Success", "Reward redeemed successfully!");
              },
              child: const Text("Redeem"),
            ),
          ],
        );
      },
    );
  }
}

class RewardItemCard extends StatelessWidget {
  final String imagePath;
  final String businessName;
  final String rewardName;
  final String heroTag;

  const RewardItemCard({
    super.key,
    required this.imagePath,
    required this.businessName,
    required this.rewardName,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: double.infinity, // Full width of the parent
                  height: 200, // Fixed height
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image loaded
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gradientEndColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SpacerBoxVertical(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                businessName,
                style: poppinsMedium(fontSize: 11.sp),
                textAlign: TextAlign.left,
              ),
            ),
            const SpacerBoxVertical(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                rewardName,
                style:
                    poppinsRegular(fontSize: 9.sp, color: AppColors.hintText),
                textAlign: TextAlign.left,
              ),
            ),
            const SpacerBoxVertical(height: 10),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imagePath;
  final String tag;

  const FullScreenImageView(
      {super.key, required this.imagePath, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: tag,
              child: Image.network(
                imagePath,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).pop(); // Close the full screen view
              },
            ),
          ),
        ],
      ),
    );
  }
}
