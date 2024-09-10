import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/business_detail_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/user/business_detail.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart'; // Import the controller

class DetailTile extends StatelessWidget {
  final String? businessId; // Optional parameter

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
                height: 200, // Set height for the image
                child: Image.network(
                  controller.userModel.value?.image ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -20,
                left: 0,
                child:
                    BackButtonWidget(), // Position BackButtonWidget as needed
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
                        style:
                            poppinsMedium(fontSize: 14), // Adjusted font size
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
                                businessLocation: user?.latLong,
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
                            fontSize: 8.sp, // Adjusted font size
                            color: AppColors.yellowColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpacerBoxVertical(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half,
                        color: AppColors.yellowColor,
                        size: 10,
                      ),
                      SpacerBoxHorizontal(width: 4),
                      Text(
                        "4.5k", // Rating from model or default
                        style: poppinsRegular(
                            fontSize: 10, color: AppColors.yellowColor),
                      ),
                    ],
                  ),
                  if (user?.phoneNo != null) SpacerBoxVertical(height: 5),
                  Row(
                    children: [
                      Icon(Icons.phone, color: AppColors.hintText, size: 10),
                      const SpacerBoxHorizontal(width: 4),
                      Text(
                        user?.phoneNo ?? TempLanguage.txtDummyPhone,
                        style: poppinsRegular(
                            fontSize: 10, color: AppColors.hintText),
                      ),
                    ],
                  ),
                  if (user?.website != null) SpacerBoxVertical(height: 5),
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
                  if (user?.latLong != null) SpacerBoxVertical(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: AppColors.hintText, size: 10),
                      const SpacerBoxHorizontal(width: 4),
                      Text(
                        "${user!.latLong!.latitude}, ${user.latLong!.longitude}",
                        style: poppinsRegular(
                            fontSize: 10, color: AppColors.hintText),
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
