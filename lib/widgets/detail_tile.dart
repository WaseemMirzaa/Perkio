import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/business_detail_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/user/business_detail.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class DetailTile extends StatelessWidget {
  final String? businessId;

  const DetailTile({super.key, this.businessId});

  @override
  Widget build(BuildContext context) {
    final BusinessDetailController controller =
        Get.put(BusinessDetailController());

    // Fetch businessId from controller
    if (businessId != null) {
      controller.fetchBusinessDetails(businessId!);
    }

    return Obx(() {
      final user = controller.userModel.value;

      return Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: user?.image == null || user?.image == ''
                    ? Center(
                        child:
                            circularProgressBar()) // Show loading indicator if no image URL
                    : Image.network(
                        user?.image ?? '',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.gradientStartColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Image.asset(AppAssets.foodImg, scale: 3),
                          );
                        },
                      ),
              ),
              Positioned(
                top: -20,
                left: 0,
                child: BackButtonWidget(
                  onBack: () {
                    Get.offAll(() => const BottomBarView(
                          isUser: true,
                        ));
                  },
                ),
              ),
            ],
          ),
          const SpacerBoxVertical(height: 5),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user?.userName ?? TempLanguage.txtBusinessName,
                        style: poppinsMedium(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessDetail(
                                businessImage: user?.image,
                                businessRating: '4.5k',
                                businessName: user?.userName,
                                businessLocation: user?.address,
                                businessPhone: user?.phoneNo,
                                businessWebsite: user?.website,
                                businessId: businessId,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          TempLanguage.txtViewDeals,
                          style: poppinsMedium(
                            fontSize: 8.sp,
                            color: AppColors.yellowColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpacerBoxVertical(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_half,
                        color: AppColors.yellowColor,
                        size: 10,
                      ),
                      const SpacerBoxHorizontal(width: 4),
                      Text(
                        "4.5k",
                        style: poppinsRegular(
                            fontSize: 10, color: AppColors.yellowColor),
                      ),
                    ],
                  ),
                  const SpacerBoxVertical(height: 5),
                  if (user?.phoneNo != null)
                    Row(
                      children: [
                        const Icon(Icons.phone,
                            color: AppColors.hintText, size: 10),
                        const SpacerBoxHorizontal(width: 4),
                        Text(
                          user?.phoneNo ?? 'No Phone available',
                          style: poppinsRegular(
                              fontSize: 10, color: AppColors.hintText),
                        ),
                      ],
                    ),
                  if (user?.website != null) const SpacerBoxVertical(height: 5),
                  Row(
                    children: [
                      Image.asset(AppAssets.globeImg, scale: 3),
                      const SpacerBoxHorizontal(width: 4),
                      Text(
                        user?.website ?? TempLanguage.txtDummyWebsite,
                        style: poppinsRegular(
                            fontSize: 10, color: AppColors.hintText),
                      ),
                    ],
                  ),
                  const SpacerBoxVertical(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.hintText,
                        size: 10,
                      ),
                      const SpacerBoxHorizontal(width: 4),
                      Expanded(
                        child: Text(
                          user?.address ?? 'No Location available',
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular(
                            fontSize: 10,
                            color: AppColors.hintText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpacerBoxVertical(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
