import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipe_app/core/utils/app_utils/location_permission_manager.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';

class HomeServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;

  Future<bool> updateCollection(
    String collectionUser,
    String docID,
    Map<String, dynamic> list,
  ) async {
    try {
      // Ensure FirebaseAuth.currentUser is not null
      if (FirebaseAuth.instance.currentUser == null) {
        log("User is not authenticated");
        return false;
      }

      String? currentUID = FirebaseAuth.instance.currentUser!.uid;

      // Update the user document
      await _db.collection(collectionUser).doc(docID).update(list);

      // Extract the necessary parameters for updating the business name
      String businessId = currentUID;

      // Ensure 'UserKey.USERNAME' exists in the list
      if (!list.containsKey(UserKey.USERNAME)) {
        log("USERNAME key not found in list");
        return false;
      }

      String newBusinessName = list[UserKey.USERNAME];

      // Update the business name in the specified collection (deals or rewards)
      await updateBusinessNameInCollection(
          CollectionsKey.REWARDS, businessId, newBusinessName);
      await updateBusinessNameInCollection(
          CollectionsKey.DEALS, businessId, newBusinessName);

      return true; // Return the result of the business name update
    } catch (e) {
      log("The error while updating is: $e");
      return false;
    }
  }

  //checking balance
  Future<bool?> checkUserBalance(String uid) async {
    try {
      // Access the 'users' collection and get the document with current user uid
      DocumentSnapshot userDoc =
          await _db.collection(CollectionsKey.USERS).doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Check if 'balance' exists and if it is greater than 0
        if (userData.containsKey('balance') && userData['balance'] != null) {
          int balance = userData['balance'];

          // Return true if balance is more than 0, false if balance is 0 or less
          return balance > 0;
        }
      }

      // If no user found or no balance field, return null
      return null;
    } catch (e) {
      // Debug print any error that occurs
      print("Error fetching user balance: $e");
      return null;
    }
  }

  // Fetch all documents matching the businessId in a collection and update their businessName
  Future<bool> updateBusinessNameInCollection(
      String collectionName, String businessId, String newBusinessName) async {
    try {
      // Fetch all documents matching the businessId in the specified collection
      var querySnapshot = await _db
          .collection(collectionName)
          .where('businessId', isEqualTo: businessId)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isEmpty) {
        log("No documents found in $collectionName with businessId: $businessId");
        return true; // No update needed, but still considered successful
      }

      // Loop through each document and update the companyName field
      for (var doc in querySnapshot.docs) {
        try {
          await doc.reference.update({
            'companyName': newBusinessName,
          });
          log("---------------------------Updated companyName in $collectionName, docId: ${doc.id}");
        } catch (updateError) {
          log("Error updating document ${doc.id} in $collectionName: $updateError");
          // Consider whether to return false here or continue updating others
        }
      }
      return true; // All updates attempted (successful or with errors)
    } catch (e) {
      log("Error while fetching documents from $collectionName: $e");
      return false; // Return false if the initial fetch fails
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
