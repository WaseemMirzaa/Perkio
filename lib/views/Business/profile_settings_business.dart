import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/app_utils/GeoLocationHelper.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/views/place_picker/place_picker.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/profile_list_items.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart' as X;

class ProfileSettingsBusiness extends StatefulWidget {
  const ProfileSettingsBusiness({super.key});

  @override
  State<ProfileSettingsBusiness> createState() =>
      _ProfileSettingsBusinessState();
}

class _ProfileSettingsBusinessState extends State<ProfileSettingsBusiness> {
  var controller = Get.find<UserController>();
  late StreamController<UserModel> _userProfileStreamController;
  late UserModel? businessProfile;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController businessIdController = TextEditingController();
  RxBool enabled = false.obs;
  final homeServices = Get.put(HomeServices());

  final HomeController homeController = Get.put(HomeController(HomeServices()));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProfileStreamController = StreamController<UserModel>();
    getUser();
  }

  @override
  void dispose() {
    _userProfileStreamController.close();
    super.dispose();
  }

  Future<void> getUser() async {
    businessProfile =
        await controller.getUser(getStringAsync(SharedPrefKey.uid));
    final address =
        await GeoLocationHelper.getCityFromGeoPoint(businessProfile!.latLong!);
    _userProfileStreamController.add(businessProfile!);
    userNameController.text = businessProfile?.userName ?? 'Not Set';
    emailController.text = businessProfile?.email ?? 'Not Set';
    phoneNoController.text = businessProfile?.phoneNo ?? 'Not Set';
    addressController.text = address ?? 'Not Set';
    websiteController.text = businessProfile?.website ?? 'Not Set';
    businessIdController.text = businessProfile?.businessId ?? 'Not Set';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: StreamBuilder<UserModel>(
            stream: _userProfileStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: circularProgressBar());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }
              final businessProfile = snapshot.data!;
              return Column(children: [
                Stack(
                  children: [
                    Obx(() {
                      return (homeController.pickedImage != null)
                          ? Image.file(
                              homeController.pickedImage!,
                              height: 30.h,
                              width: 100.w,
                              fit: BoxFit.cover,
                            )
                          : !getStringAsync(SharedPrefKey.photo).isEmptyOrNull
                              ? Image.network(
                                  getStringAsync(SharedPrefKey.photo),
                                  height: 30.h,
                                  width: 100.w,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  AppAssets.imageHeader,
                                  fit: BoxFit.fill,
                                  height: 30.h,
                                  width: 100.w,
                                );
                    }),
                    BackButtonWidget(),
                    Positioned(
                      right: 3.w,
                      top: 6.h,
                      child: GestureDetector(
                        onTap: () {
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                      'Pick Image',
                                      style: poppinsBold(fontSize: 15),
                                    ),
                                    content: const Text(
                                        'Upload profile from gallery or catch with Camera'),
                                    actions: [
                                      IconButton(
                                          onPressed: () async {
                                            Get.back();
                                            await homeController
                                                .pickImageFromGallery()
                                                .then((value) async {
                                              String? path = await homeController
                                                  .uploadImageToFirebaseOnID(
                                                      homeController.pickedImage
                                                              ?.path ??
                                                          '',
                                                      getStringAsync(
                                                          SharedPrefKey.uid));
                                              if (!path.isEmptyOrNull) {
                                                homeController.updateCollection(
                                                    getStringAsync(
                                                        SharedPrefKey.uid),
                                                    'users',
                                                    {UserKey.IMAGE: path});
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.drive_file_move_outline)),
                                      IconButton(
                                          onPressed: () async {
                                            Get.back();
                                            await homeController
                                                .pickImageFromCamera()
                                                .then((value) async {
                                              String? path = await homeController
                                                  .uploadImageToFirebaseOnID(
                                                      homeController.pickedImage
                                                              ?.path ??
                                                          '',
                                                      getStringAsync(
                                                          SharedPrefKey.uid));
                                              print("The path is: === $path");
                                              if (!path.isEmptyOrNull) {
                                                print("DB called");
                                                homeController.updateCollection(
                                                    getStringAsync(
                                                        SharedPrefKey.uid),
                                                    'users',
                                                    {UserKey.IMAGE: path});
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.camera_alt_outlined)),
                                    ],
                                  ));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                                color: AppColors.whiteColor,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.camera_enhance_rounded,
                              size: 20.sp,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Obx(() {
                  return !enabled.value
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: GestureDetector(
                                onTap: () async {
                                  if (enabled.value) {
                                    bool success = await homeController
                                        .updateCollection(
                                            getStringAsync(SharedPrefKey.uid),
                                            CollectionsKey.USERS, {
                                      UserKey.USERNAME: userNameController.text,
                                      UserKey.EMAIL: emailController.text,
                                      UserKey.PHONENO: phoneNoController.text,
                                      UserKey.LATLONG: addressController.text,
                                      UserKey.WEBSITE: websiteController.text,
                                      UserKey.BUSINESSID:
                                          businessIdController.text
                                    });
                                    if (success) {
                                      X.showSnackBar('Success',
                                          'User data updated successfully!');
                                      enabled.value = false;
                                    } else {
                                      X.showSnackBar(
                                        'Error',
                                        'Failed to update user data.',
                                      );
                                    }
                                  } else {
                                    enabled.value = true;
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 16.sp,
                                      color: AppColors.hintText,
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Text(
                                      TempLanguage.txtEdit,
                                      style: poppinsRegular(
                                          fontSize: 12.sp,
                                          color: AppColors.hintText),
                                    ),
                                  ],
                                )),
                          ),
                        )
                      : SizedBox(
                          height: 2.h,
                        );
                }),
                Expanded(
                  child: Obx(
                    () => ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      children: [
                        ProfileListItems(
                          path: AppAssets.profile1,
                          textController: userNameController,
                          enabled: enabled.value,
                               hasHintText: true,
                        hintText: 'Enter User Name',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ProfileListItems(
                          path: AppAssets.call,
                             hasHintText: true,
                        hintText: 'Enter Phone Number',
                          textController: phoneNoController,
                          enabled: enabled.value,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ProfileListItems(
                          path: AppAssets.profile3,
                          textController: emailController,
                           hasHintText: true,
                        hintText: 'Enter Email Address',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ProfileListItems(
                          path: AppAssets.profile4,
                          textController: addressController,
                           hasHintText: true,
                        hintText: 'Enter Address',
                          onTap: enabled.value
                              ? () async {
                                  final currentPosition =
                                      await homeServices.getCurrentLocation();

                                  AddressModel address = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LocationService(
                                              child: PlacesPick(
                                                  changeCurrentLocation: LatLng(
                                                    currentPosition!.latitude,
                                                    currentPosition.longitude,
                                                  ),
                                                  currentLocation: LatLng(
                                                      businessProfile
                                                          .latLong!.latitude,
                                                      businessProfile.latLong!
                                                          .longitude)))));
                                  addressController.text =
                                      address.subAdministrativeArea.toString();
                                  await setValue(
                                      SharedPrefKey.latitude, address.latitude);
                                  await setValue(SharedPrefKey.longitude,
                                      address.longitude);
                                }
                              : null,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ProfileListItems(
                          path: AppAssets.world,
                          textController: websiteController,
                          enabled: enabled.value,
                           hasHintText: true,
                        hintText: 'Enter Website',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ProfileListItems(
                          path: AppAssets.profile6,
                          textController: businessIdController,
                          enabled: enabled.value,
                           hasHintText: true,
                        hintText: 'Enter Google Business ID',
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        !enabled.value
                            ? const SizedBox()
                            : ButtonWidget(
                                onSwipe: () async {
                                  if (enabled.value) {
                                    // Validate input fields
                                    if (userNameController.text.isEmptyOrNull) {
                                      X.showSnackBar('Fields Required',
                                          'Name is required.');
                                    } else if (emailController
                                        .text.isEmptyOrNull) {
                                      X.showSnackBar('Fields Required',
                                          'Email is required.');
                                    } else if (phoneNoController
                                        .text.isEmptyOrNull) {
                                      X.showSnackBar('Fields Required',
                                          'Phone is required.');
                                    } else if (addressController
                                        .text.isEmptyOrNull) {
                                      X.showSnackBar('Fields Required',
                                          'Address is required.');
                                    } else if (websiteController
                                        .text.isEmptyOrNull) {
                                      X.showSnackBar('Fields Required',
                                          'Website is required.');
                                    } else if (businessIdController
                                        .text.isEmptyOrNull) {
                                      X.showSnackBar('Fields Required',
                                          'Business ID is required.');
                                    } else {
                                      // Check if business ID is valid
                                      var businessDetails = await homeController
                                          .fetchBusinessDetails(
                                              businessIdController.text);

                                      if (businessDetails != null &&
                                          businessDetails.status == "OK") {
                                        // Update user data if Place ID is valid
                                        bool success = await homeController
                                            .updateCollection(
                                                getStringAsync(
                                                    SharedPrefKey.uid),
                                                CollectionsKey.USERS,
                                                {
                                              UserKey.USERNAME:
                                                  userNameController.text,
                                              UserKey.EMAIL:
                                                  emailController.text,
                                              UserKey.PHONENO:
                                                  phoneNoController.text,
                                              UserKey.LATLONG: GeoPoint(
                                                  getDoubleAsync(
                                                      SharedPrefKey.latitude),
                                                  getDoubleAsync(
                                                      SharedPrefKey.longitude)),
                                              UserKey.WEBSITE:
                                                  websiteController.text,
                                              UserKey.BUSINESSID:
                                                  businessIdController.text
                                            });

                                        // Update the business details in the subcollection
                                        await homeController
                                            .createBusinessDetailsSubcollection(
                                                getStringAsync(
                                                    SharedPrefKey.uid),
                                                businessDetails);

                                        if (success) {
                                          X.showSnackBar('Success',
                                              'User data updated successfully!');
                                          enabled.value = false;
                                        } else {
                                          X.showSnackBar('Error',
                                              'Failed to update user data.');
                                        }
                                      } else {
                                        X.showSnackBar(
                                            'Error', 'Invalid Business ID.');
                                      }
                                    }
                                  } else {
                                    enabled.value = true;
                                  }
                                },
                                text: !enabled.value
                                    ? TempLanguage.txtEdit
                                    : 'Save',
                              ),
                      ],
                    ),
                  ),
                ),
              ]);
            }));
  }
}
/**
 *
 *
 * */