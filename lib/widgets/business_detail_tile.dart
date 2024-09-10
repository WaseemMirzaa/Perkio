import 'package:cloud_firestore/cloud_firestore.dart';
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
  final GeoPoint? location;
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
      padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
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
              SpacerBoxVertical(height: 5),
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
              SpacerBoxVertical(height: 5),
              if (rating != null)
                Row(
                  children: [
                    Icon(
                      Icons.star_half,
                      color: AppColors.yellowColor,
                      size: 10,
                    ),
                    SpacerBoxHorizontal(width: 4),
                    Text(
                      rating!,
                      style: poppinsRegular(
                          fontSize: 10, color: AppColors.yellowColor),
                    ),
                  ],
                ),
              SpacerBoxVertical(height: 5),
              if (phone != null)
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: AppColors.hintText,
                      size: 10,
                    ),
                    SpacerBoxHorizontal(width: 4),
                    Text(
                      phone!,
                      style: poppinsRegular(
                          fontSize: 10, color: AppColors.hintText),
                    ),
                  ],
                ),
              SpacerBoxVertical(height: 5),
              if (website != null)
                Row(
                  children: [
                    Image.asset(
                      AppAssets.globeImg,
                      scale: 3,
                    ),
                    SpacerBoxHorizontal(width: 4),
                    Text(
                      website!,
                      style: poppinsRegular(
                          fontSize: 10, color: AppColors.hintText),
                    ),
                  ],
                ),
              SpacerBoxVertical(height: 5),
              if (location != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.hintText,
                      size: 10,
                    ),
                    SpacerBoxHorizontal(width: 4),
                    Text(
                      location!.latitude.toString() +
                          ', ' +
                          location!.longitude.toString(),
                      style: poppinsRegular(
                          fontSize: 10, color: AppColors.hintText),
                    ),
                  ],
                ),
              SpacerBoxVertical(height: 5),
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
