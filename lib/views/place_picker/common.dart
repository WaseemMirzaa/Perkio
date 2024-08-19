import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/views/place_picker/get_current_location.dart';

Future<CurrentLocationModel> getAddressFromLatLng(
    {AddressModel? address, LatLng? latLon}) async {
  CurrentLocationModel locationModel = CurrentLocationModel();
  Position? currentPosition;
  try {
    currentPosition = await Geolocator.getCurrentPosition();
    locationModel.latLon = LatLng(currentPosition.latitude, currentPosition.longitude);

    // await Geolocator.getCurrentPosition(
    //         desiredAccuracy: LocationAccuracy.medium,
    //         forceAndroidLocationManager: true)
    //     .then((Position position) {
    //   currentPosition = position;
    //
    //   locationModel.latLon = LatLng(position.latitude, position.longitude);
    // });

    List<Placemark> placeMarks = await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude);
    Placemark place = placeMarks.first;
    locationModel.address = AddressModel(
        latitude: currentPosition?.latitude,
        longitude: currentPosition?.longitude,
        administrativeArea: place.administrativeArea,
        country: place.country,
        isoCountryCode: place.isoCountryCode,
        locality: place.locality,
        name: place.name,
        postalCode: place.postalCode,
        street: place.street,
        subAdministrativeArea: place.subAdministrativeArea,
        subLocality: place.subLocality,
        subThoroughfare: place.subThoroughfare,
        thoroughfare: place.thoroughfare);
    return locationModel;
  } catch (e) {
    if (kDebugMode) {
      toast(e.toString());
      print(e);
    }
    // throw Exception("Error Fetching Location");
  }
  return locationModel;
}
