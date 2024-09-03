import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class GeoLocationHelper {
  static Future<String?> getAddressFromGeoPoint(GeoPoint geoPoint) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(geoPoint.latitude, geoPoint.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placeMark = placemarks.first;
        return "${placeMark.street}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.country}";
      } else {
        return "";
      }
    } catch (e) {
      print("Error getting address: $e");
      return "";
    }
  }

  static Future<String?> getCityFromGeoPoint(GeoPoint? geoPoint) async {
    if (geoPoint == null) {
      return null; // or handle as needed
    }
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(geoPoint.latitude, geoPoint.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placeMark = placemarks.first;
        return "${placeMark.locality}";
      } else {
        return "";
      }
    } catch (e) {
      print("Error getting address: $e");
      return "";
    }
  }
}
