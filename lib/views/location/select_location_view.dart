import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/views/place_picker/place_picker.dart';
import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';

class SelectLocation extends StatefulWidget {
  final UserModel userModel;
  const SelectLocation({super.key, required this.userModel});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  late GoogleMapController mapController;
  LatLng _initialPosition = const LatLng(37.42796133580664, -122.085749655962);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(22.h),
        child: customAppBar(
          isSearchField: true,
          isLocation: false,
          isNotification: false,
        ),
      ),
      body: LocationService(
        child: PlacesPick(
          isUserLocation: true,
          userModel: widget.userModel,
          currentLocation: _initialPosition,
        ),
      ),
    );
  }
}



//  ProfileListItems(
//                           path: AppAssets.profile4,
//                           textController: addressController,
//                           onTap: enabled.value
//                               ? () async {
//                                   AddressModel address = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => LocationService(
//                                               child: PlacesPick(
//                                                   currentLocation: LatLng(
//                                                       businessProfile
//                                                           .latLong!.latitude,
//                                                       businessProfile.latLong!
//                                                           .longitude)))));
//                                   if (address != null) {
//                                     addressController.text = await address!
//                                         .subAdministrativeArea
//                                         .toString();
//                                     await setValue(SharedPrefKey.latitude,
//                                         address!.latitude);
//                                     await setValue(SharedPrefKey.longitude,
//                                         address!.longitude);
//                                   }
//                                 }
//                               : null,
//                         ),,
