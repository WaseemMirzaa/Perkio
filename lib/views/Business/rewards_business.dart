import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/core/utils/app_utils/GeoLocationHelper.dart';
import 'package:swipe_app/core/utils/constants/app_statics.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/views/business/add_rewards.dart';
import 'package:swipe_app/views/notifications/notifications_view.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/views/place_picker/place_picker.dart';
import 'package:swipe_app/widgets/business_rewards_tiles.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/primary_layout_widget/primary_layout.dart';

import '../../core/utils/constants/app_const.dart';
import '../../widgets/custom_appBar/custom_appBar.dart';

class RewardsBusiness extends StatefulWidget {
  const RewardsBusiness({super.key});

  @override
  State<RewardsBusiness> createState() => _RewardsBusinessState();
}

class _RewardsBusinessState extends State<RewardsBusiness> {
  final businessController = Get.put(BusinessController(BusinessServices()));

  @override
  Widget build(BuildContext context) {
    return PrimaryLayoutWidget(
      // header: SizedBox(height: 16.h,child: customAppBar(),),
      header: SizedBox(
        height: 14.95.h,
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.header,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.sp,
                          backgroundImage:
                              !getStringAsync(SharedPrefKey.photo).isEmptyOrNull
                                  ? NetworkImage(
                                      getStringAsync(SharedPrefKey.photo))
                                  : const AssetImage(AppAssets.profileImg),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getStringAsync(SharedPrefKey.userName),
                                style: poppinsRegular(fontSize: 13.sp),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  AddressModel address = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlacesPick(
                                                currentLocation: LatLng(
                                                    getDoubleAsync(
                                                        SharedPrefKey.latitude),
                                                    getDoubleAsync(SharedPrefKey
                                                        .longitude)),
                                              )));

                                  print(
                                      "Address is \n\n\n ${address.latitude}");
                                  final add = await GeoLocationHelper
                                      .getCityFromGeoPoint(GeoPoint(
                                          address.latitude!,
                                          address.longitude!));
                                  await setValue(SharedPrefKey.address, add);
                                  await setValue(
                                      SharedPrefKey.latitude, address.latitude);
                                  await setValue(SharedPrefKey.longitude,
                                      address.longitude);
                                  await homeController.updateCollection(
                                      getStringAsync(SharedPrefKey.uid),
                                      CollectionsKey.USERS, {
                                    UserKey.LATLONG: GeoPoint(
                                        getDoubleAsync(SharedPrefKey.latitude),
                                        getDoubleAsync(SharedPrefKey.longitude))
                                  }).then((value) {
                                    setState(() {
                                      print("Rebuild");
                                    });
                                  });
                                },
                                child: Row(
                                  children: [
                                    FutureBuilder(
                                        future: GeoLocationHelper
                                            .getCityFromGeoPoint(AppStatics
                                                    .geoPoint ??
                                                GeoPoint(
                                                    getDoubleAsync(
                                                        SharedPrefKey.latitude),
                                                    getDoubleAsync(SharedPrefKey
                                                        .longitude))),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text(
                                              "Loading...",
                                              style: poppinsRegular(
                                                  fontSize: 10.sp,
                                                  color: AppColors.hintText),
                                            );
                                          }
                                          return Text(
                                            (snapshot.data?.length ?? 0) > 20
                                                ? '${snapshot.data!.substring(0, 20)}...'
                                                : snapshot.data ?? 'Loading...',
                                            style: poppinsRegular(
                                              fontSize: 10.sp,
                                              color: AppColors.hintText,
                                            ),
                                          );
                                        }),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Change Location',
                                      style: poppinsRegular(
                                          fontSize: 8,
                                          color: AppColors.blueColor),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const NotificationsView());
                          },
                          child: Obx(() {
                            return Stack(
                              children: [
                                Image.asset(
                                  AppAssets.notificationImg,
                                  scale: 3.5,
                                ),
                                // Display unread count badge if greater than 0
                                if (notificationController
                                        .unreadBusinessNotificationCount.value >
                                    0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '${notificationController.unreadBusinessNotificationCount.value}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 17.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                TempLanguage.lblMyRewards,
                style: poppinsMedium(fontSize: 18),
              ),
            ),
            SpacerBoxVertical(height: 1.h),
            StreamBuilder<List<RewardModel>>(
                stream: businessController
                    .getMyRewardsDeal(getStringAsync(SharedPrefKey.uid)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: circularProgressBar());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Rewards available'));
                  }
                  final rewardsDeal = snapshot.data!;
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: rewardsDeal.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final rewards = rewardsDeal[index];
                        return BusinessRewardsTiles(
                          rewardModel: rewards,
                        );
                      });
                }),
            SpacerBoxVertical(height: 10.h),
          ],
        ),
      ),
      footer: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ButtonWidget(
              onSwipe: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRewards()));
              },
              text: TempLanguage.btnLblSwipeToAddRewards),
        ),
      ),
    );
  }
}
