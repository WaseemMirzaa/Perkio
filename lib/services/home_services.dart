import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipe_app/core/utils/app_utils/location_permission_manager.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';

class HomeServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;

  Future<bool> updateCollection(
      String collectionName, String docID, Map<String, dynamic> list) async {
    try {
      await _db.collection(collectionName).doc(docID).update(list);
      return true;
    } catch (e) {
      log("The error while updating is: $e");
      return false;
    }
  }

  Future<String?> uploadImageToFirebaseOnID(String image, String userId) async {
    try {
      final storageReference = _storage.ref().child('profile/$userId');
      await storageReference.putFile(File(image));
      final downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("Error is: $e");
      return null;
    }
  }

  Future<String?> uploadImageToFirebaseWithCustomPath(
      String image, String path) async {
    try {
      final storageReference = _storage.ref().child(path);
      await storageReference.putFile(File(image));
      final downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("Error is: $e");
      return null;
    }
  }

  Future<LatLng?> getCurrentLocation({BuildContext? context}) async {
    LatLng? latLng;
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latLng = LatLng(position.latitude, position.longitude);
      await setValue(SharedPrefKey.latitude, latLng.latitude);
      await setValue(SharedPrefKey.longitude, latLng.longitude);

      log("✔✔✔✔✔✔✔ LATITUDE WHEN APP STARTED: ${latLng.latitude}");
      log(" ✔✔✔✔✔✔✔✔ LONGITUDE WHEN APP STARTED: ${latLng.longitude}");
      // } catch (e) {
      //   print('Error: $e');
      // }
    } else {
      await LocationPermissionManager
          .requestLocationPermissionWithConsentDialog(
              scaffoldContext: context!,
              onGranted: () async {
                print("ON GRANTED");
                await getCurrentLocation();
              },
              onDenied: () async {
                print("ON DENIED");
                showAdaptiveDialog(
                    context: context,
                    builder: (context) => const PermissionDeniedDialog());
              });
    }
    return latLng;
  }

  Future<Placemark?> getAddress(LatLng latLng) async {
    try {
      var address = await GeocodingPlatform.instance!
          .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (address.isNotEmpty) {
        var placeMark = address.first;
        return placeMark;
      } else {
        print("No placemarks found");
        return null;
      }
    } catch (e) {
      print("Error getting address: $e");
      return null;
    }
  }
}
