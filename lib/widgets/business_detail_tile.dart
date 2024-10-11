import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class BusinessDetailTile extends StatelessWidget {
  final String? image;
  final String? businessName;
  final String? rating;
  final String? website;
  final String? location;
  final String? phone;

  const BusinessDetailTile({
    super.key,
    this.image,
    this.businessName,
    this.rating,
    this.website,
    this.location,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image != null)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Image.network(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              const SpacerBoxVertical(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    businessName ?? TempLanguage.txtBusinessName,
                    style: poppinsMedium(fontSize: 14),
                  ),
                  GestureDetector(
                      onTap: () {
                        // Handle tap event here
                        Get.back();
                      },
                      child: Text(
                        TempLanguage.txtViewRating,
                        style: poppinsMedium(
                            fontSize: 8.sp, color: AppColors.yellowColor),
                      )),
                ],
              ),
              const SpacerBoxVertical(height: 5),
              if (rating != null)
                Row(
                  children: [
                    const Icon(
                      Icons.star_half,
                      color: AppColors.yellowColor,
                      size: 10,
                    ),
                    const SpacerBoxHorizontal(width: 4),
                    Text(
                      rating!,
                      style: poppinsRegular(
                          fontSize: 10, color: AppColors.yellowColor),
                    ),
                  ],
                ),
              const SpacerBoxVertical(height: 5),
              if (phone != null)
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: AppColors.hintText,
                      size: 10,
                    ),
                    const SpacerBoxHorizontal(width: 4),
                    Text(
                      phone!,
                      style: poppinsRegular(
                          fontSize: 10, color: AppColors.hintText),
                    ),
                  ],
                ),
              const SpacerBoxVertical(height: 5),
              Row(
                children: [
                  Image.asset(
                    AppAssets.globeImg,
                    scale: 3,
                  ),
                  const SpacerBoxHorizontal(width: 4),
                  Text(
                    website!,
                    style:
                        poppinsRegular(fontSize: 10, color: AppColors.hintText),
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
                    // Wrap the Text widget in Expanded to take up available space
                    child: Text(
                      location ?? 'No Location available',
                      overflow: TextOverflow.ellipsis, // Add this line
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
