import 'package:get/get.dart';
import 'package:skhickens_app/services/home_services.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';

class HomeController extends GetxController{
  HomeServices homeService;
  HomeController(this.homeService);

  final Rx<File?> _pickedImage = Rx<File?>(null);
  Rx<File?> _pickedImage2 = Rx<File?>(null);
  final RxString? _pickedStringImage = RxString('');
  String originalPath = '';

  // Getters for reactive variables
  File? get pickedImage => _pickedImage.value;
  File? get pickedImage2 => _pickedImage2.value;
  String? get pickedStringImage => _pickedStringImage?.value;

  // Picking image from camera
  Future<void> pickImageFromCamera({bool isCropActive = true, bool isLogo = false}) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if(isLogo){
        _pickedImage2.value = File(image!.path);
      }else {
        _pickedImage.value = File(image!.path);
        _pickedStringImage?.value = image.toString();
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
  Future<void> pickImageFromGallery({bool isCropActive = true, bool isLogo = false}) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if(isLogo){
        _pickedImage2.value = File(image!.path);
      }else {
        _pickedImage.value = File(image!.path);
        _pickedStringImage?.value = image.toString();
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
    _pickedStringImage?.value = '';

    // Notify listeners via GetX
    update();
  }

  void clearLogo(){
    _pickedImage2.value = null;
    update();
  }

  Future<bool> updateCollection(String docID, String collectionName, Map<String, dynamic> list )async{
    return await homeService.updateCollection(collectionName, docID, list);
  }

  Future<String?> uploadImageToFirebaseOnID(String image, String userId) async {
    return await homeService.uploadImageToFirebaseOnID(image, userId);
  }
  Future<String?> uploadImageToFirebaseWithCustomPath(String image, String path) async {
    return await homeService.uploadImageToFirebaseWithCustomPath(image, path);
  }
}