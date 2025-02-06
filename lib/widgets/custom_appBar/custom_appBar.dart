import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

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
import 'package:swipe_app/widgets/dialog_box_for_signup.dart';
import '../../core/utils/constants/app_assets.dart';

final homeController = Get.put(HomeController(HomeServices()));
final userController = Get.put(UserController(UserServices()));
final notificationController = Get.find<NotificationController>();
final homeServices = Get.put(HomeServices());
Address? address;

Widget customAppBar({
  String? userName,
  String? userImage,
  String? userLocation,
  BuildContext? context,
  String hintText = 'Search',
  double? latitude,
  double? longitude,
  bool isUser = false,
  bool isGuestLogin = false,
  bool isLocation = true,
  bool isNotification = true,
  bool isChangeBusinessLocation = false,
  TextEditingController? textController, // Add this parameter
  Function(String)? onChanged,
  bool isSearchField = false,
  Color appBarBackColor = AppColors.appBarBackColor,
  Widget? widget,
  RxBool? isSearching, // Add RxBool parameter
  bool? isReward,
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
                    backgroundImage: userImage != null && userImage.isNotEmpty
                        ? NetworkImage(userImage)
                        : const AssetImage('assets/images/logo.png'),
                    //userImage != null
                    //     ? NetworkImage(userImage)
                    //     : const AssetImage(AppAssets.profileImg),
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
                                  isGuestLogin
                                      ? GestureDetector(
                                          onTap: () {
                                            LoginRequiredDialog.show(context!,isUser);
                                          },
                                          child: Text(
                                            'Change Location',
                                            style: poppinsRegular(
                                              fontSize: 8,
                                              color: AppColors.blueColor,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            BuildContext context = Get.context!;
                                            try {
                                              print(
                                                  'Change Location tapped.'); // Log the tap event

                                              // Get the current location
                                              final currentPosition =
                                                  await homeServices
                                                      .getCurrentLocation();
                                              if (currentPosition == null) {
                                                print(
                                                    'Current position is null.'); // Log if the current position is null
                                                // Show an error message to the user

                                                return;
                                              }
                                              print(
                                                  'Current Position: $currentPosition'); // Log the current position

                                              // Navigate to location picker and get the selected address
                                              final address =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LocationService(
                                                    child: PlacesPick(
                                                      isChangeBusinessLocation:
                                                          isChangeBusinessLocation,
                                                      changeCurrentLocation:
                                                          LatLng(
                                                        currentPosition
                                                            .latitude,
                                                        currentPosition
                                                            .longitude,
                                                      ),
                                                      currentLocation: LatLng(
                                                        latitude ??
                                                            getDoubleAsync(
                                                                SharedPrefKey
                                                                    .latitude),
                                                        longitude ??
                                                            getDoubleAsync(
                                                                SharedPrefKey
                                                                    .longitude),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );

                                              print(
                                                  'Address returned from PlacesPick: $address'); // Log the returned address

                                              // If address is null, gracefully handle it
                                              if (address == null) {
                                                print(
                                                    'No address selected.'); // Log if no address was selected
                                                // Show a message to the user

                                                return;
                                              }

                                              // Get the city name from the geolocation
                                              final add =
                                                  await GeoLocationHelper
                                                      .getCityFromGeoPoint(
                                                GeoPoint(address.latitude!,
                                                    address.longitude!),
                                              );
                                              print(
                                                  'City fetched from GeoPoint: $add'); // Log the fetched city

                                              // Update the Shared Preferences with new address and location
                                              await setValue(
                                                  SharedPrefKey.address, add);
                                              await setValue(
                                                  SharedPrefKey.latitude,
                                                  address.latitude);
                                              await setValue(
                                                  SharedPrefKey.longitude,
                                                  address.longitude);
                                              print(
                                                  'Shared Preferences updated. Address: $add, Latitude: ${address.latitude}, Longitude: ${address.longitude}'); // Log the updated values

                                              // Update the user's collection with the new address and location
                                              await homeController
                                                  .updateCollection(
                                                getStringAsync(
                                                    SharedPrefKey.uid),
                                                CollectionsKey.USERS,
                                                {
                                                  UserKey.ADDRESS: add,
                                                  UserKey.LATLONG: GeoPoint(
                                                    getDoubleAsync(
                                                        SharedPrefKey.latitude),
                                                    getDoubleAsync(SharedPrefKey
                                                        .longitude),
                                                  ),
                                                },
                                              );
                                              print(
                                                  'User collection updated successfully.'); // Log success message
                                            } catch (e) {
                                              // Handle any errors that occur during the process
                                              print(
                                                  'Error updating location: $e'); // Log the error
                                              // Show an error message to the user
                                            }
                                          },
                                          child: Text(
                                            'Change Location',
                                            style: poppinsRegular(
                                              fontSize: 8,
                                              color: AppColors.blueColor,
                                            ),
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
                            notificationController.markNotificationAsRead();
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
                      : GestureDetector(
                          onTap: () {
                            notificationController.markNotificationAsRead();
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
                        ),
                ],
              ),
              isSearchField
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFieldWidget(
                        text: hintText,
                        textController: textController!,
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
