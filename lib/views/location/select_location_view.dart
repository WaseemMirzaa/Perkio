import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:swipe_app/core/utils/app_utils/location_permission_manager.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/views/place_picker/place_picker.dart';

class SelectLocation extends StatefulWidget {
  final UserModel userModel;
  const SelectLocation({super.key, required this.userModel});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  late GoogleMapController mapController;
  final homeServices = HomeServices();
  LatLng? latLng;
  AddressModel? address;
  bool isPermitted = false;
  bool isLoading = true; // Track loading state
  TextEditingController businessAddressController = TextEditingController();

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
      });
      await _getAndFill();
    } else {
      setState(() {
        isPermitted = false;
        isLoading = false; // Stop loading if permission is denied
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
        businessAddressController.text =
            "${currentLocation?.street}, ${currentLocation?.locality}, ${currentLocation?.administrativeArea}, ${currentLocation?.country}";
      }
    } catch (e) {
      print("Error getting location: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading once location is fetched
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
    print("Current Address: ${address!.completeAddress}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Show a loading indicator while fetching location
            )
          : isPermitted && latLng != null
              ? LocationService(
                  child: PlacesPick(
                    isUserLocation: true,
                    userModel: widget.userModel,
                    currentLocation: latLng!,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Location permission is required to show the map.'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading =
                                true; // Show loading indicator while retrying
                          });
                          await _initializeLocation(); // Retry permission and location initialization
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
