import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:swipe_app/models/business_details_model.dart';
import 'package:swipe_app/services/home_services.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:swipe_app/views/place_picker/apis.dart';

class HomeController extends GetxController {
  HomeServices homeService;
  HomeController(this.homeService);

  final Rx<File?> _pickedImage = Rx<File?>(null);
  final Rx<File?> _pickedImage2 = Rx<File?>(null);
  final RxString _pickedStringImage = RxString('');
  String originalPath = '';

  // Getters for reactive variables
  File? get pickedImage => _pickedImage.value;
  File? get pickedImage2 => _pickedImage2.value;
  String? get pickedStringImage => _pickedStringImage.value;

  // Picking image from camera
  Future<void> pickImageFromCamera(
      {bool isCropActive = true, bool isLogo = false}) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if (isLogo) {
        _pickedImage2.value = File(image!.path);
      } else {
        _pickedImage.value = File(image!.path);
        _pickedStringImage.value = image.toString();
        // Notify listeners via GetX
        update();
      }
      if (isCropActive) {
        await cropImage();
        await compressImage();
      } else {
        await compressImage();
      }

      _pickedImage.value = File(originalPath);

      // Notify listeners via GetX
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Picking image from gallery
  Future<void> pickImageFromGallery(
      {bool isCropActive = true, bool isLogo = false}) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (isLogo) {
        _pickedImage2.value = File(image!.path);
      } else {
        _pickedImage.value = File(image!.path);
        _pickedStringImage.value = image.toString();
        update();
      }
      if (isCropActive) {
        await cropImage();
        await compressImage();
      } else {
        await compressImage();
      }

      _pickedImage.value = File(originalPath);

      // Notify listeners via GetX
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Compressing the image
  Future<void> compressImage() async {
    originalPath = "${_pickedImage.value!.path}_original";
    FlutterImageCompress.validator.ignoreCheckExtName = true;
    await FlutterImageCompress.compressAndGetFile(
      _pickedImage.value!.path,
      originalPath,
      quality: 60,
      minHeight: 600,
      minWidth: 600,
    );
    print("\n\n\n\nCompressed\n\n\n\n");
  }

  // Cropping the image
  Future<void> cropImage() async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedImage.value!.path,
        maxWidth: 150,
        maxHeight: 150,
        aspectRatio: const CropAspectRatio(ratioX: 150, ratioY: 150),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColors.gradientStartColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        _pickedImage.value = File(croppedFile.path);
        log("Cropped");

        // Notify listeners via GetX
        update();
      } else {
        print("NULL");
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
  }

  // Resetting the image selection
  Future<void> setImageNull() async {
    _pickedImage.value = null;
    _pickedStringImage.value = '';

    // Notify listeners via GetX
    update();
  }

  void clearLogo() {
    _pickedImage2.value = null;
    update();
  }

  Future<BusniessDetailsModel?> fetchBusinessDetails(String placeID) async {
    try {
      // Make the API request

      final apiUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=${Apis.apiKey}";
      final response = await http.get(Uri.parse(apiUrl));

      // Check if the response status is OK
      if (response.statusCode == 200) {
        print("API call successful.");

        // Parse the response body
        final jsonResponse = json.decode(response.body);
        print("Response JSON: $jsonResponse");

        // Create the BusinessDetailsModel from the response
        BusniessDetailsModel businessDetails = BusniessDetailsModel(
          htmlAttributions: jsonResponse['html_attributions'],
          result: jsonResponse['result'] != null
              ? Result(
                  name: jsonResponse['result']['name'],
                  rating: jsonResponse['result']['rating'],
                  reviews: (jsonResponse['result']['reviews'] as List)
                      .map((reviewJson) => Review(
                            authorName: reviewJson['author_name'],
                            authorUrl: reviewJson['author_url'],
                            language: reviewJson['language'],
                            originalLanguage: reviewJson['original_language'],
                            profilePhotoUrl: reviewJson['profile_photo_url'],
                            rating: reviewJson['rating'],
                            relativeTimeDescription:
                                reviewJson['relative_time_description'],
                            text: reviewJson['text'],
                            time: reviewJson['time'],
                            translated: reviewJson['translated'],
                          ))
                      .toList())
              : null,
          status: jsonResponse['status'],
        );

        return businessDetails;
      } else {
        // Handle non-200 responses
        print("API call failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred while fetching business details: $e");
      return null;
    }
  }

  Future<void> createBusinessDetailsSubcollection(
      String userId, BusniessDetailsModel businessDetails) async {
    try {
      // Reference to the business details subcollection
      CollectionReference businessDetailsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('business_details');

      // Fetch the documents in the business details collection
      QuerySnapshot querySnapshot = await businessDetailsCollection.get();

      // Prepare the data to store in Firestore
      Map<String, dynamic> businessData = {
        'business_detail_firebase_id': '', // Placeholder for the document ID
        ...businessDetails.toMap(),
      };

      if (querySnapshot.docs.isNotEmpty) {
        // If there are existing documents, update the first one
        DocumentSnapshot existingDoc = querySnapshot.docs.first;
        businessData['business_detail_firebase_id'] = existingDoc.id;
        await existingDoc.reference.set(businessData, SetOptions(merge: true));
      } else {
        // If there are no documents, create a new one with a random ID
        DocumentReference newDocRef =
            businessDetailsCollection.doc(); // Create a new random doc ID
        businessData['business_detail_firebase_id'] = newDocRef.id;
        await newDocRef.set(businessData);
      }
    } catch (e) {
      print("Error creating or updating business details subcollection: $e");
    }
  }

  Future<bool> updateCollection(
      String docID, String collectionName, Map<String, dynamic> list) async {
    return await homeService.updateCollection(collectionName, docID, list);
  }

  Future<String?> uploadImageToFirebaseOnID(String image, String userId) async {
    return await homeService.uploadImageToFirebaseOnID(image, userId);
  }

  Future<String?> uploadImageToFirebaseWithCustomPath(
      String image, String path) async {
    return await homeService.uploadImageToFirebaseWithCustomPath(image, path);
  }
}
