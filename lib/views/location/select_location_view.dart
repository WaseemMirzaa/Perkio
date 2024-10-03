import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_utils/location_permission_manager.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/services/push_notification_service.dart';
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
  TextEditingController businessAddressController = TextEditingController();

  final UserController controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
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

        businessAddressController.text =
            "${currentLocation?.street}, ${currentLocation?.locality}, ${currentLocation?.administrativeArea}, ${currentLocation?.country}";

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

       String token = await FCMManager.getFCMToken();
       widget.userModel.fcmTokens = [token];

      // Call signup
      await controller.signUp(widget.userModel, () {
        // Navigate back in case of an error
        Get.back();
      },false);
    } catch (e) {
      // Optionally show an error message to the user
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

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Location permission is required to proceed.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _initializeLocation(); // Retry permission and location initialization
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
