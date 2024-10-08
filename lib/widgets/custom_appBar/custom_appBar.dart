import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/controllers/notification_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/app_utils/GeoLocationHelper.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/notifications/notifications_view.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/views/place_picker/place_picker.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import '../../core/utils/constants/app_assets.dart';

final homeController = Get.put(HomeController(HomeServices()));
final userController = Get.put(UserController(UserServices()));
final notificationController = Get.put(NotificationController());

Widget customAppBar({
  String? userName,
  String? userImage,
  String? userLocation,
  String hintText = 'Search',
  double? latitude,
  double? longitude,
  bool isLocation = true,
  bool isNotification = true,
  Function(String)? onChanged,
  bool isSearchField = false,
  Color appBarBackColor = AppColors.appBarBackColor,
  Widget? widget,
  RxBool? isSearching, // Add RxBool parameter
}) {
  return Padding(
    padding: EdgeInsets.only(top: 1.h),
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
                            ? NetworkImage(getStringAsync(SharedPrefKey.photo))
                            : AssetImage(userImage ?? AppAssets.profileImg),
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
                          userName ?? getStringAsync(SharedPrefKey.userName),
                          style: poppinsRegular(fontSize: 13.sp),
                        ),
                        isLocation
                            ? Row(
                                children: [
                                  FutureBuilder(
                                      future: GeoLocationHelper
                                          .getCityFromGeoPoint(GeoPoint(
                                              getDoubleAsync(
                                                  SharedPrefKey.latitude),
                                              getDoubleAsync(
                                                  SharedPrefKey.longitude))),
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
                                          (userLocation?.length ?? 0) > 20
                                              ? '${userLocation!.substring(0, 20)}...'
                                              : userLocation ?? 'Loading...',
                                          style: poppinsRegular(
                                            fontSize: 10.sp,
                                            color: AppColors.hintText,
                                          ),
                                        );
                                      }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      AddressModel address =
                                          await Get.to(() => LocationService(
                                                  child: PlacesPick(
                                                currentLocation: LatLng(
                                                    latitude!, longitude!),
                                              )));
                                      final add = await GeoLocationHelper
                                          .getCityFromGeoPoint(GeoPoint(
                                              address.latitude!,
                                              address.longitude!));
                                      await setValue(
                                          SharedPrefKey.address, add);
                                      await setValue(SharedPrefKey.latitude,
                                          address.latitude);
                                      await setValue(SharedPrefKey.longitude,
                                          address.longitude);

                                      await homeController.updateCollection(
                                          getStringAsync(SharedPrefKey.uid),
                                          CollectionsKey.USERS, {
                                        UserKey.ADDRESS: add,
                                        UserKey.LATLONG: GeoPoint(
                                            getDoubleAsync(
                                                SharedPrefKey.latitude),
                                            getDoubleAsync(
                                                SharedPrefKey.longitude)),
                                      });
                                    },
                                    child: Text(
                                      'Change Location',
                                      style: poppinsRegular(
                                          fontSize: 8,
                                          color: AppColors.blueColor),
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  isNotification
                      ? GestureDetector(
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
                                        .unreadUserNotificationCount.value >
                                    0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '${notificationController.unreadUserNotificationCount.value}',
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
                      : const SizedBox.shrink(),
                ],
              ),
              isSearchField
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFieldWidget(
                        text: hintText,
                        textController: TextEditingController(),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.hintText,
                        ),
                        onChanged: (value) {
                          if (onChanged != null) {
                            onChanged(value);
                            isSearching?.value = value.isNotEmpty;
                          }
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget customAppBarWithTextField({
  String? userName,
  String? userImage,
  GeoPoint? geoPoint,
  String hintText = 'Search',
  bool isLocation = true,
  required TextEditingController searchController,
  Function(String)? onChanged,
  Function()? onTap,
  bool isReadyOnly = false,
  Color appBarBackColor = AppColors.appBarBackColor,
  Widget? widget,
}) =>
    Padding(
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
                      backgroundImage: !getStringAsync(SharedPrefKey.photo)
                              .isEmptyOrNull
                          ? NetworkImage(getStringAsync(SharedPrefKey.photo))
                          : AssetImage(userImage ?? AppAssets.profileImg),
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
                            userName ?? getStringAsync(SharedPrefKey.userName),
                            style: poppinsRegular(fontSize: 13.sp),
                          ),
                          isLocation
                              ? GestureDetector(
                                  onTap: () async {
                                    AddressModel address =
                                        await Get.to(() => PlacesPick(
                                              currentLocation: LatLng(
                                                  getDoubleAsync(
                                                      SharedPrefKey.latitude),
                                                  getDoubleAsync(
                                                      SharedPrefKey.longitude)),
                                            ));
                                    print("Address is : ${address.locality}");
                                    final add = await GeoLocationHelper
                                        .getCityFromGeoPoint(GeoPoint(
                                            address.latitude!,
                                            address.longitude!));
                                    await setValue(SharedPrefKey.address, add);
                                    await setValue(SharedPrefKey.latitude,
                                        address.latitude);
                                    await setValue(SharedPrefKey.longitude,
                                        address.longitude);
                                    await homeController.updateCollection(
                                        getStringAsync(SharedPrefKey.uid),
                                        CollectionsKey.USERS, {
                                      UserKey.LATLONG: GeoPoint(
                                          getDoubleAsync(
                                              SharedPrefKey.latitude),
                                          getDoubleAsync(
                                              SharedPrefKey.longitude))
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      FutureBuilder(
                                          future: GeoLocationHelper
                                              .getCityFromGeoPoint(geoPoint ??
                                                  GeoPoint(
                                                      getDoubleAsync(
                                                          SharedPrefKey
                                                              .latitude),
                                                      getDoubleAsync(
                                                          SharedPrefKey
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
                                              snapshot.data ?? 'Loading...',
                                              style: poppinsRegular(
                                                  fontSize: 10.sp,
                                                  color: AppColors.hintText),
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
                                )
                              : widget!,
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => const NotificationsView());
                        },
                        child: Image.asset(
                          AppAssets.notificationImg,
                          scale: 3.5,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFieldWidget(
                    text: hintText,
                    textController: searchController,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.hintText,
                    ),
                    onChanged: onChanged,
                    onTap: onTap,
                    // isReadOnly: isReadyOnly,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
