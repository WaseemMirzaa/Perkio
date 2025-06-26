import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/user/business_rating_details.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class BusinessDetailTile extends StatelessWidget {
  final String? image;
  final String? businessName;
  final String? rating;
  final String? website;
  final String? location;
  final String? phone;
  final String? businessId;

  const BusinessDetailTile({
    super.key,
    this.image,
    this.businessName,
    this.rating,
    this.website,
    this.location,
    this.phone,
    this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 150, // Adjusted height to fit the content
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display image if available
              if (image != null && image!.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Image.network(
                    image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  ),
                ),
              const SpacerBoxVertical(height: 5),

              // Business name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    businessName ?? TempLanguage.txtBusinessName,
                    style: poppinsMedium(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle tap event here
                      Get.to(() => BusinessRatingDetailsScreen(
                            businessDetailsId: businessId,
                          ));
                    },
                    child: Text(
                      TempLanguage.txtViewRating,
                      style: poppinsMedium(
                          fontSize: 10.sp, color: AppColors.yellowColor),
                    ),
                  ),
                ],
              ),
              const SpacerBoxVertical(height: 5),

              // Business rating (optional)
              if (rating != null && rating!.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.star_half,
                      color: AppColors.yellowColor,
                      size: 12,
                    ),
                    const SpacerBoxHorizontal(width: 4),
                    Text(
                      rating!,
                      style: poppinsRegular(
                          fontSize: 12, color: AppColors.yellowColor),
                    ),
                  ],
                ),
              const SpacerBoxVertical(height: 5),

              // Phone number (optional)
              if (phone != null && phone!.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: AppColors.hintText,
                      size: 12,
                    ),
                    const SpacerBoxHorizontal(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onLongPress: () {
                          Clipboard.setData(ClipboardData(text: phone!));

                        },
                        child: Text(
                          phone!,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular(fontSize: 12, color: AppColors.hintText),
                        ),
                      ),
                    ),
                  ],
                ),

              if (phone != null && phone!.isNotEmpty)
                const SpacerBoxVertical(height: 5),

// Website (optional)
              if (website != null && website!.isNotEmpty)
                Row(
                  children: [
                    Image.asset(AppAssets.globeImg, scale: 3),
                    const SpacerBoxHorizontal(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onLongPress: () {
                          Clipboard.setData(ClipboardData(text: website!));

                        },
                        child: Text(
                          website!,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular(fontSize: 12, color: AppColors.hintText),
                        ),
                      ),
                    ),
                  ],
                ),

              const SpacerBoxVertical(height: 5),

// Location (optional)
              if (location != null && location!.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.hintText,
                      size: 12,
                    ),
                    const SpacerBoxHorizontal(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onLongPress: () {
                          Clipboard.setData(ClipboardData(text: location!));

                        },
                        child: Text(
                          location!,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular(fontSize: 12, color: AppColors.hintText),
                        ),
                      ),
                    ),
                  ],
                ),

              const SpacerBoxVertical(height: 5),

              // Divider at the bottom
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
    );
  }
}
