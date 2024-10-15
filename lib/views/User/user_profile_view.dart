import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart' as NBUtils;
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/app_utils/GeoLocationHelper.dart';
import 'package:swipe_app/core/utils/app_utils/location_permission_manager.dart';
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
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/profile_list_items.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart';
import '../../widgets/snackbar_widget.dart' as X;

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  var controller = Get.find<UserController>();
  late StreamController<UserModel> _userProfileStreamController;
  late UserModel? userProfile;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  //open map to fetch this points
  TextEditingController addressController = TextEditingController();
  final homeServices = Get.put(HomeServices());

  var add;

  RxBool enabled = false.obs;

  final homeController = Get.put(HomeController(HomeServices()));

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
    userProfile =
        await controller.getUser(NBUtils.getStringAsync(SharedPrefKey.uid));

    // Store original values
    final address = userProfile!.address ?? 'No Address';
    userNameController.text = userProfile?.userName ?? '';
    emailController.text = userProfile?.email ?? '';
    phoneNoController.text = userProfile?.phoneNo ?? '';
    addressController.text = address;

    _userProfileStreamController.add(userProfile!);
  }

  AddressModel? address;
  LatLng? latLng;

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
            final userProfile = snapshot.data!;

            return Column(
              children: [
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
                          : SizedBox(
                              height: 30.h,
                              width: 100.w,
                              child: Image.network(
                                userProfile.image ?? '',
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.gradientEndColor,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Image.asset(
                                      AppAssets.imageHeader,
                                      fit: BoxFit.fill,
                                      height: 30.h,
                                      width: 100.w,
                                    ),
                                  );
                                },
                              ),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                          onTap: () async {
                            if (enabled.value) {
                              // Check if any of the fields have changed
                              bool isChanged = false;
                              if (userNameController.text !=
                                  userProfile.userName) isChanged = true;
                              if (emailController.text != userProfile.email) {
                                isChanged = true;
                              }
                              if (phoneNoController.text !=
                                  userProfile.phoneNo) {
                                isChanged = true;
                              }
                              if (addressController.text !=
                                  userProfile.address) {
                                isChanged = true;
                              }

                              if (latLng != null) {
                                GeoPoint updatedLatLng = GeoPoint(
                                    latLng!.latitude, latLng!.longitude);
                                if (updatedLatLng != userProfile.latLong) {
                                  isChanged = true;
                                }
                              }

                              if (isChanged) {
                                // Proceed with update if any change is detected
                                bool success = await homeController
                                    .updateCollection(
                                        NBUtils.getStringAsync(
                                            SharedPrefKey.uid),
                                        CollectionsKey.USERS,
                                        {
                                      UserKey.USERNAME: userNameController.text,
                                      UserKey.EMAIL: emailController.text,
                                      UserKey.PHONENO: phoneNoController.text,
                                      if (latLng != null) UserKey.ADDRESS: add,
                                      if (latLng !=
                                          null) // Only add LATLONG if latLng is not null
                                        UserKey.LATLONG: GeoPoint(
                                            latLng!.latitude,
                                            latLng!.longitude),
                                    });

                                if (success) {
                                  showSnackBar('Success',
                                      'User data updated successfully!');
                                  enabled.value = false;
                                } else {
                                  showSnackBar(
                                      'Error', 'Failed to update user data.');
                                }
                              } else {
                                // If no fields have changed, don't save
                                showSnackBar(
                                    'Info', 'No changes made to update.');
                              }
                            } else {
                              enabled.value = true;
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!enabled.value)
                                Icon(
                                  Icons.edit,
                                  size: 16.sp,
                                  color: AppColors.hintText,
                                ),
                              if (enabled.value)
                                Icon(
                                  Icons.save,
                                  size: 16.sp,
                                  color: AppColors.hintText,
                                ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Text(
                                !enabled.value ? TempLanguage.txtEdit : 'Save',
                                style: poppinsRegular(
                                    fontSize: 12, color: AppColors.hintText),
                              ),
                            ],
                          )),
                    );
                  }),
                ),
                Expanded(
                    child: Obx(
                  () => ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      ProfileListItems(
                        path: AppAssets.profile1,
                        textController: userNameController,
                        enabled: enabled.value,
                      ),
                      ProfileListItems(
                        path: AppAssets.call,
                        textController: phoneNoController,
                        enabled: enabled.value,
                      ),
                      ProfileListItems(
                        path: AppAssets.profile3,
                        textController: emailController,
                      ),
                      ProfileListItems(
                        path: AppAssets.profile4,
                        textController: addressController,
                        onTap: enabled.value
                            ? () async {
                                bool isPremitt =
                                    await LocationPermissionManager()
                                        .requestLocationPermission(context);
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=> LocationChangeScreen()));
                                if (isPremitt) {
                                  print(SharedPrefKey.latitude.toDouble() +
                                      SharedPrefKey.longitude.toDouble());

                                  final currentPosition =
                                      await homeServices.getCurrentLocation();

                                  address = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LocationService(
                                              child: PlacesPick(
                                                  changeCurrentLocation: LatLng(
                                                    currentPosition!.latitude,
                                                    currentPosition.longitude,
                                                  ),
                                                  currentLocation: latLng ??
                                                      LatLng(
                                                          userProfile.latLong!
                                                              .latitude,
                                                          userProfile.latLong!
                                                              .longitude)))));
                                  if (address != null) {
                                    latLng = LatLng(address!.latitude!,
                                        address!.longitude!);
                                    log('**${latLng!.latitude}');
                                    log('**${latLng!.longitude}');
                                    add = await GeoLocationHelper
                                        .getCityFromGeoPoint(GeoPoint(
                                            address!.latitude!,
                                            address!.longitude!));
                                    addressController.text =
                                        address!.completeAddress.toString();
                                    await setValue(SharedPrefKey.latitude,
                                        address!.latitude);
                                    await setValue(SharedPrefKey.longitude,
                                        address!.longitude);
                                    await setValue(SharedPrefKey.address, add);
                                  }
                                } else {
                                  X.showSnackBar('Allow Location Permissions',
                                      'Please allow location permissions');
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                )),
              ],
            );
          }),
    );
  }
}
