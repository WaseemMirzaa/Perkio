import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/common_space.dart';

class FavouritesWidget extends StatelessWidget {
  final String dealId;
  final String dealName;
  final String restaurantName;
  final String dealPrice;
  final String uses;
  final String location;
  final String image;
  final double rating;
  final bool isFavScreen;

  const FavouritesWidget({
    super.key,
    this.rating = 4.4,
    this.dealId = '',
    this.dealName = 'Deal Name',
    this.restaurantName = 'Restaurant Name',
    this.dealPrice = '\$25',
    this.image = '',
    this.uses = '3',
    this.location = '4773 Waldeck Street, US',
    this.isFavScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    RxBool isFav = true.obs;
    final UserController controller = Get.find<UserController>();

    return isFavScreen
        ? Obx(() {
            return isFav.value
                ? Container(
                    height: 140,
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 1, color: AppColors.borderColor),
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
                                if (image.isNotEmpty)
                                  Container(
                                    height: 14.h,
                                    width: 14.h,
                                    margin: EdgeInsets.only(
                                        top: 7.sp, left: 6.sp, bottom: 7.sp),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius:
                                          BorderRadius.circular(14.sp),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.blackColor
                                              .withOpacity(0.16),
                                          offset: const Offset(0, 3),
                                          blurRadius: 6.5,
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: Image.asset(
                                      AppAssets.restaurantImg1,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                            Positioned(
                              left: 0
                                  .sp, // Positioning for the like/unlike button
                              top: 0
                                  .sp, // Positioning for the like/unlike button
                              child: Obx(() {
                                final isFavorite =
                                    controller.favoriteCache[dealId] ?? false;

                                return IconButton(
                                  onPressed: () async {
                                    if (isFavorite) {
                                      controller.decreaseDealLikes(dealId);
                                      await controller.unLikeDeal(dealId);
                                      isFav.value = false;
                                      controller.favoriteCache[dealId] =
                                          false; // Update cache
                                    } else {
                                      controller.incrementDealLikes(dealId);
                                      await controller.likeDeal(dealId);
                                      controller.favoriteCache[dealId] =
                                          true; // Update cache
                                    }
                                    // Update UI after operation
                                  },
                                  padding: EdgeInsets.zero,
                                  icon: ImageIcon(
                                    AssetImage(
                                      isFavorite
                                          ? AppAssets.likeFilledImg
                                          : AppAssets.likeImg,
                                    ),
                                    size: 12.sp,
                                    color: isFavorite
                                        ? AppColors.redColor
                                        : AppColors.hintText,
                                  ),
                                );
                              }),
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
                              SizedBox(
  width: 150.0,  // Set the desired width for the text container
  child: Text(
    dealName,
    style: poppinsMedium(fontSize: 13.sp),
    overflow: TextOverflow.ellipsis,  // Adds "..." if the text overflows
    maxLines: 1,  // Ensure text stays on a single line
  ),
),
                              const SpacerBoxVertical(height: 5),
                              Text(
                                restaurantName,
                                style: poppinsRegular(
                                    fontSize: 10.sp, color: AppColors.hintText),
                              ),
                              const SpacerBoxVertical(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_half,
                                    color: AppColors.yellowColor,
                                    size: 15,
                                  ),
                                  Text(
                                    rating.toString(),
                                    style: poppinsRegular(
                                        fontSize: 10.sp,
                                        color: AppColors.yellowColor),
                                  ),
                                ],
                              ),
                              const SpacerBoxVertical(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.hintText,
                                    size: 11.sp,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            location,
                                            style: poppinsRegular(
                                                fontSize: 10.sp,
                                                color: AppColors.hintText),
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SpacerBoxHorizontal(width: 4),
                                      ],
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: 1.5.h),
                              const SpacerBoxVertical(height: 10),
                              Text(
                                'USES $uses',
                                style: poppinsMedium(fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          })
        : Container(
            height: 140,
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
                        if (image.isNotEmpty)
                          Container(
                            height: 14.h,
                            width: 14.h,
                            margin: EdgeInsets.only(
                                top: 7.sp, left: 6.sp, bottom: 7.sp),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(14.sp),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blackColor.withOpacity(0.16),
                                  offset: const Offset(0, 3),
                                  blurRadius: 6.5,
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: Image.asset(
                              AppAssets.restaurantImg1,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                    Positioned(
                      left: 0.sp, // Positioning for the like/unlike button
                      top: 0.sp, // Positioning for the like/unlike button
                      child: Obx(() {
                        final isFavorite =
                            controller.favoriteCache[dealId] ?? false;

                        return IconButton(
                          onPressed: () async {
                            if (isFavorite) {
                              controller.decreaseDealLikes(dealId);
                              await controller.unLikeDeal(dealId);

                              controller.favoriteCache[dealId] =
                                  false; // Update cache
                            } else {
                              controller.incrementDealLikes(dealId);
                              await controller.likeDeal(dealId);
                              controller.favoriteCache[dealId] =
                                  true; // Update cache
                            }
                            // Update UI after operation
                          },
                          padding: EdgeInsets.zero,
                          icon: ImageIcon(
                            AssetImage(
                              isFavorite
                                  ? AppAssets.likeFilledImg
                                  : AppAssets.likeImg,
                            ),
                            size: 12.sp,
                            color: isFavorite
                                ? AppColors.redColor
                                : AppColors.hintText,
                          ),
                        );
                      }),
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
                      SizedBox(
  width: 150.0,
  child: Text(
    dealName,
    style: poppinsMedium(fontSize: 13.sp),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,  
  ),
),
                      const SpacerBoxVertical(height: 5),
                      Text(
                        restaurantName,
                        style: poppinsRegular(
                            fontSize: 10.sp, color: AppColors.hintText),
                      ),
                      const SpacerBoxVertical(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_half,
                            color: AppColors.yellowColor,
                            size: 15,
                          ),
                          Text(
                            rating.toString(),
                            style: poppinsRegular(
                                fontSize: 10.sp, color: AppColors.yellowColor),
                          ),
                        ],
                      ),
                      const SpacerBoxVertical(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.hintText,
                            size: 11.sp,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    location,
                                    style: poppinsRegular(
                                        fontSize: 10.sp,
                                        color: AppColors.hintText),
                                    maxLines: 2,
                                  ),
                                ),
                                const SpacerBoxHorizontal(width: 4),
                              ],
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 1.5.h),
                      const SpacerBoxVertical(height: 10),
                      Text(
                        'USES $uses',
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
