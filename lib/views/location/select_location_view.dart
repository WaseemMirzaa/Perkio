import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
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
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/widgets/common_comp.dart';

class SelectLocation extends StatefulWidget {
  final UserModel userModel;

  const SelectLocation({super.key, required this.userModel});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  final homeServices = HomeServices();
  LatLng? latLng;
  AddressModel? address;
  bool isPermitted = false; // Track location permission state
  bool isLoading = false; // Track loading state for location fetching

  final UserController controller = Get.put(UserController(UserServices()));

  @override
  void initState() {
    super.initState();

    _initializeLocation();
  }

  Future<void> getAndFill() async {
    if (await LocationPermissionManager().requestLocationPermission(context)) {
      latLng = await homeServices.getCurrentLocation(context: context);
      final currentLocation =
          await homeServices.getAddress(latLng ?? const LatLng(0, 0));
      await addingAddress(currentLocation ?? const Placemark());
    }
  }

  Future<void> addingAddress(Placemark currentAddress) async {
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
      latitude: getDoubleAsync(SharedPrefKey.latitude),
      longitude: getDoubleAsync(SharedPrefKey.longitude),
    );
    log(address!.completeAddress.toString());
    log("CURRENT ADDRESS MODEL>>>>>>>>>>>>>>>>>>>>>>>>. ${address!.country}");
  }

  Future<void> _initializeLocation() async {
    bool permissionGranted =
        await LocationPermissionManager().requestLocationPermission(context);

    if (permissionGranted) {
      setState(() {
        isPermitted = true;
        isLoading = true; // Set loading state while fetching location
      });
      await _getAndFill();
    } else {
      setState(() {
        isPermitted = false; // Stop loading if permission is denied
      });
    }
  }

  Future<void> _getAndFill() async {
    try {
      latLng = await homeServices.getCurrentLocation(context: context);
      if (latLng != null) {
        final currentLocation =
            await homeServices.getAddress(latLng ?? const LatLng(0, 0));
        await _addingAddress(currentLocation ?? const Placemark());

        // Print latitude, longitude, and complete address in debug console
        print("Latitude: ${latLng?.latitude}");
        print("Longitude: ${latLng?.longitude}");
        print("Complete Address: ${address?.completeAddress}");

        // Call signUp method after fetching location
        await _callSignUp();
      }
    } catch (e) {
      print("Error getting location: $e");
      Get.snackbar('Error', 'Failed to fetch location: $e');
    } finally {
      setState(() {
        isLoading = false; // Reset loading state
      });
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
      widget.userModel.latLong = geoPoint;
      widget.userModel.address = address?.completeAddress ?? "";

      await setValue(SharedPrefKey.latitude, address!.latitude);
      await setValue(SharedPrefKey.longitude, address!.longitude);

      String? token = await FCMManager.getFCMToken();
      widget.userModel.fcmTokens = [token!];

      // Call signup
      await controller.signUp(widget.userModel, (error) {
        if (error != null) {
          Get.snackbar('Error', error, snackPosition: SnackPosition.TOP);
        }
      }, false);
    } catch (e) {
      Get.snackbar('Error', 'Sign up failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Observe the loading state from the controller
        if (controller.loading.value) {
          return Center(
              child:
                  circularProgressBar()); // Show loading indicator for sign up
        }

        // Show loading indicator for fetching location if isLoading is true
        if (isLoading) {
          return Center(child: circularProgressBar());
        }

        return Container(
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Title or main message
                  Text(
                    'Swipe',
                    style:
                        altoysFont(fontSize: 45, color: AppColors.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h), // Space between title and text

                  // Secondary message (Optional, add if needed)
                  Text(
                    'Allowing location access helps us recommend personalized deals and rewards near you. '
                    'Please grant location permissions to unlock the best offers available in your area.',
                    style: poppinsRegular(
                      color: AppColors.whiteColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h), // Space between message and button

                  // Button container
                  GestureDetector(
                    onTap: () async {
                      await _initializeLocation(); // Retry permission and location initialization
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.sp, horizontal: 24.sp),
                      decoration: BoxDecoration(
                        color: Colors.white, // Button background color
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      child: Text(
                        'Allow Permission',
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
          ),
        );
      }),
    );
  }
}
