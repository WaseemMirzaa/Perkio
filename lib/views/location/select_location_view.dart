import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/app_utils/location_permission_manager.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/fcm_manager.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';

class SelectLocation extends StatefulWidget {
  final UserModel? userModel;
  final bool isGuestUser;
  final bool isUser;

  const SelectLocation(
      {super.key,
      this.userModel,
      this.isGuestUser = false,
      this.isUser = false});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {

  final RxBool isLoading = false.obs;
  final homeServices = HomeServices();
  LatLng? latLng;
  AddressModel? address;
  // final RxBool shouldShowPermissionUI = false.obs;
  // final RxBool isProcessing = true.obs;
  Rx<PermissionStatus>? permissionStatusObx = Rx<PermissionStatus>(PermissionStatus.denied) ;

  final UserController controller = Get.put(UserController(UserServices()));

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {

    try {

      permissionStatusObx?.value =
          await LocationPermissionManager().requestLocationPermission(context);

      if (permissionStatusObx?.value == PermissionStatus.granted) {

       _handlePermissionGranted();

      }

    } catch (e) {

    }
  }

  Future<void> _handleGuestUser() async {
    try {

      latLng = await homeServices.getCurrentLocation(context);
      if (latLng != null) {
        final currentLocation =
            await homeServices.getAddress(latLng ?? const LatLng(0, 0));

        // Save location to shared preferences
        await setValue(SharedPrefKey.latitude, latLng!.latitude);
        await setValue(SharedPrefKey.longitude, latLng!.longitude);

        // // Save complete address if needed
        if (currentLocation != null) {
          String completeAddress =
              "${currentLocation.street}, ${currentLocation.administrativeArea}, ${currentLocation.country}";
          await setValue(SharedPrefKey.userAddress, completeAddress);
        }

        // Navigate to home screen
        Get.offAll(() => BottomBarView(
              isUser: widget.isUser,
              isGuestLogin: true,
            ));
      }
    } catch (e) {
      print("Error handling guest user: $e");
      Get.snackbar('Error', 'Failed to fetch location: $e',
          snackPosition: SnackPosition.TOP);
      // shouldShowPermissionUI.value = true;
    } finally {
      // isProcessing.value = false;
    }
  }

  Future<void> _getAndFill() async {
    try {
      // isProcessing.value = true;
      // shouldShowPermissionUI.value = false;

      latLng = await homeServices.getCurrentLocation(context);
      if (latLng != null) {
        final currentLocation =
            await homeServices.getAddress(latLng ?? const LatLng(0, 0));
        await _addingAddress(currentLocation ?? const Placemark());
        await _callSignUp();
      }
    } catch (e) {
      print("Error getting location: $e");
      Get.snackbar('Error', 'Failed to fetch location: $e');
      // shouldShowPermissionUI.value = true;
    } finally {
      // Only set isProcessing to false if we're showing the permission UI
      // if (shouldShowPermissionUI.value) {
      //   isProcessing.value = false;
      // }
    }
  }

  Future<void> _addingAddress(Placemark currentAddress) async {
    address = AddressModel(
      administrativeArea: currentAddress.administrativeArea,
      subAdministrativeArea: currentAddress.subAdministrativeArea,
      completeAddress:
          "${currentAddress.street}, ${currentAddress.administrativeArea}, ${currentAddress.country}",
      country: currentAddress.country,
      isoCountryCode: currentAddress.isoCountryCode,
      locality: currentAddress.locality,
      subLocality: currentAddress.subLocality,
      name: currentAddress.name,
      postalCode: currentAddress.postalCode,
      street: currentAddress.street,
      subThoroughfare: currentAddress.subThoroughfare,
      thoroughfare: currentAddress.thoroughfare,
      latitude: latLng?.latitude ?? 0.0,
      longitude: latLng?.longitude ?? 0.0,
    );
  }

  Future<void> _callSignUp() async {
    try {
      GeoPoint geoPoint =
          GeoPoint(address?.latitude ?? 0.0, address?.longitude ?? 0.0);
      widget.userModel!.latLong = geoPoint;
      widget.userModel!.address = address?.completeAddress ?? "";

      await setValue(SharedPrefKey.latitude, address!.latitude);
      await setValue(SharedPrefKey.longitude, address!.longitude);

      String? token = await FCMManager.getFCMToken();
      widget.userModel!.fcmTokens = [token!];

      await controller.signUp(widget.userModel!, (error) {
        if (error != null) {
          Get.snackbar('Error', error, snackPosition: SnackPosition.TOP);
          // shouldShowPermissionUI.value = true;
          // isProcessing.value = false;
        }
      }, false);
    } catch (e) {
      Get.snackbar('Error', 'Sign up failed: $e');
      // shouldShowPermissionUI.value = true;
      // isProcessing.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStartColor,
                  AppColors.gradientEndColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Obx(() {
            // Show loading indicator if processing or controller is loading
            if (permissionStatusObx == null) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Please wait we\'re fetching your location.',
                    style: poppinsRegular(
                      color: AppColors.whiteColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ));
            }

            // Only show permission UI if explicitly set to true
            if (permissionStatusObx != null
            && permissionStatusObx?.value != PermissionStatus.granted ) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Allowing location access helps us recommend personalized deals and rewards near you. '
                        'Please grant location permissions to unlock the best offers available in your area.',
                        style: poppinsRegular(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap: ()  async {
                          _initializeLocation();                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.sp, horizontal: 24.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Allow Permission From Settings',
                            style: poppinsRegular(
                              color: AppColors.blackColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Return loading indicator as default state
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Please wait we\'re fetching your location',
                  style: poppinsRegular(
                    color: AppColors.whiteColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ));
          }),
        ],
      ),
    );
  }

  Future<void> _handlePermissionGranted() async {

    if (widget.isGuestUser) {

      await _handleGuestUser();

    } else {

      await _getAndFill();

    }
  }
}
