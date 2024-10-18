// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/controllers/notification_controller.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_utils/location_permission_manager.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/fcm_manager.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/business/verification_pending_view.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/views/place_picker/place_picker.dart';
import 'package:swipe_app/widgets/auth_components/authComponents.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';
import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';
import '../../widgets/snackbar_widget.dart' as X;

class AddBusinessDetailsView extends StatefulWidget {
  AddBusinessDetailsView({super.key, required this.userModel});
  UserModel userModel;

  @override
  State<AddBusinessDetailsView> createState() => _AddBusinessDetailsViewState();
}

class _AddBusinessDetailsViewState extends State<AddBusinessDetailsView> {
  final businessIdController = TextEditingController();

  bool isLoading = true;

  final businessAddressController = TextEditingController();

  final websiteController = TextEditingController();

  final homeController = Get.put(HomeController(HomeServices()));

  final userController = Get.put(UserController(UserServices()));

  final businessAddressNode = FocusNode();

  final websiteNode = FocusNode();

  final businessIDNode = FocusNode();
  final homeServices = HomeServices();
  LatLng? latLng;
  AddressModel? address;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      if (address != null) {
        businessAddressController.text = address!.completeAddress!;
      } else {
        await homeServices.getCurrentLocation(context: context).then((value) {
          print("Then Called");
          getAndFill();
        });
      }
      setState(() {
        isLoading = false; // Enable onTap after microtask is complete
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        homeController.setImageNull();
        homeController.clearLogo();
        return true;
      },
      child: LoaderOverlay(
        child: SecondaryLayoutWidget(
          header: Stack(children: [
            CustomShapeContainer(
              height: 22.h,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerBoxVertical(height: 40),
                  BackButtonWidget(
                    padding: EdgeInsets.zero,
                  ),
                  Center(
                      child: Text(
                    'Add Business Info',
                    style: poppinsMedium(fontSize: 25),
                  ))
                ],
              ),
            ),
          ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 21.h,
                  ),
                  Text(
                    'Business Address',
                    style: poppinsRegular(fontSize: 13),
                  ),
                  const SpacerBoxVertical(height: 10),
                  // Declare a loading state variable

                  TextFieldWidget(
                    text: 'Business Address',
                    textController: businessAddressController,
                    focusNode: businessAddressNode,
                    isReadOnly: true,
                    onEditComplete: () =>
                        focusChange(context, businessAddressNode, websiteNode),
                    onTap: isLoading
                        ? null
                        : () async {
                            bool isPremitt = await LocationPermissionManager()
                                .requestLocationPermission(context);

                            if (isPremitt) {
                              final currentPosition =
                                  await homeServices.getCurrentLocation();
                              address = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocationService(
                                          child: PlacesPick(
                                              changeCurrentLocation:
                                                  currentPosition!,
                                              currentLocation: latLng ??
                                                  const LatLng(-97.00000000,
                                                      38.00000000)))));
                              if (address != null) {
                                businessAddressController.text =
                                    address!.completeAddress.toString();
                                log(businessAddressController.text);
                                await setValue(
                                    SharedPrefKey.latitude, address!.latitude);
                                await setValue(SharedPrefKey.longitude,
                                    address!.longitude);
                              }
                            } else {
                              X.showSnackBar('Allow Location Permissions',
                                  'Please allow location permissions');
                            }
                          },
                  ),

                  const SpacerBoxVertical(height: 20),
                  Text(
                    'Website',
                    style: poppinsRegular(fontSize: 13),
                  ),
                  const SpacerBoxVertical(height: 10),
                  TextFieldWidget(
                    text: 'Website',
                    textController: websiteController,
                    focusNode: websiteNode,
                    onEditComplete: () =>
                        focusChange(context, websiteNode, businessIDNode),
                  ),
                  const SpacerBoxVertical(height: 20),
                  Text(
                    'Google Business ID',
                    style: poppinsRegular(fontSize: 13),
                  ),
                  const SpacerBoxVertical(height: 10),
                  TextFieldWidget(
                    text: 'Google Business ID',
                    textController: businessIdController,
                    focusNode: businessIDNode,
                    onEditComplete: () => unFocusChange(context),
                  ),
                  const SpacerBoxVertical(height: 20),
                  Text(
                    'Logo',
                    style: poppinsRegular(fontSize: 13),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Obx(
                      () => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          uploadImageComp(homeController.pickedImage2, () {
                            showAdaptiveDialog(
                                context: context,
                                builder: (context) =>
                                    imageDialog(galleryTap: () {
                                      Get.back();
                                      homeController.pickImageFromGallery(
                                          isCropActive: false, isLogo: true);
                                    }, cameraTap: () {
                                      Get.back();
                                      homeController.pickImageFromCamera(
                                          isCropActive: false, isLogo: true);
                                    }));
                          }),
                          Positioned(
                              top: -1.h,
                              right: -0.8.h,
                              child: IconButton(
                                iconSize: 18.sp,
                                onPressed: () {
                                  homeController.clearLogo();
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Business Images',
                    style: poppinsRegular(fontSize: 13),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Obx(
                      () => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          uploadImageComp(homeController.pickedImage, () {
                            showAdaptiveDialog(
                                context: context,
                                builder: (context) =>
                                    imageDialog(galleryTap: () {
                                      Get.back();
                                      homeController.pickImageFromGallery(
                                          isCropActive: false);
                                    }, cameraTap: () {
                                      Get.back();
                                      homeController.pickImageFromCamera(
                                          isCropActive: false);
                                    }));
                          }),
                          Positioned(
                              top: -1.h,
                              right: -0.8.h,
                              child: IconButton(
                                iconSize: 18.sp,
                                onPressed: () {
                                  homeController.setImageNull();
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  SpacerBoxVertical(height: 3.h),
                  ButtonWidget(
                    onSwipe: () async {
                      print(
                          "The LOGO is: ${homeController.pickedImage2?.path} \n and \n The Business Image is ${homeController.pickedImage?.path}");
                      if (businessAddressController.text.isEmptyOrNull) {
                        X.showSnackBar('Fields Required',
                            'Please enter the business address');
                      } else if (websiteController.text.isEmptyOrNull) {
                        X.showSnackBar(
                            'Fields Required', 'Please enter the website');
                      } else if (businessIdController.text.isEmptyOrNull) {
                        X.showSnackBar('Fields Required',
                            'Please enter the Google Business ID');
                      } else if (homeController.pickedImage2 == null) {
                        X.showSnackBar('Fields Required',
                            'Please upload the business Logo');
                      } else if (homeController.pickedImage == null) {
                        X.showSnackBar('Fields Required',
                            'Please upload the business image');
                      } else {
                        context.loaderOverlay.show(
                          widgetBuilder: (context) =>
                              Center(child: circularProgressBar()),
                        );
                        widget.userModel.latLong = GeoPoint(
                            getDoubleAsync(SharedPrefKey.latitude),
                            getDoubleAsync(SharedPrefKey.longitude));
                        widget.userModel.website = websiteController.text;
                        widget.userModel.businessId = businessIdController.text;
                        widget.userModel.address =
                            businessAddressController.text;

                        if (getStringAsync(SharedPrefKey.role) ==
                            SharedPrefKey.business) {
                          widget.userModel.image =
                              homeController.pickedImage?.path;
                          widget.userModel.logo =
                              homeController.pickedImage2?.path;
                        }

                        //test placeID = 'ChIJN1t_tDeuEmsRUsoyG83frY4'
                        //tets placeID = 'ChIJrTLr-GyuEmsRBfy61i59si0'

                        String? token = await FCMManager.getFCMToken();
                        widget.userModel.fcmTokens = [token!];

                        // Await the signUp call and only navigate if it was successful
                        await userController.signUp(widget.userModel, (error) {
                          // Error callback, just hide the loader and stay on the current screen
                          if (error != null) {
                            Get.snackbar('Error', error,
                                snackPosition: SnackPosition.TOP);
                          }
                          context.loaderOverlay.hide();
                        }, true, businessIdController.text).then((value) {
                          // Navigate only if signup didn't fail
                          print(
                              'HERE IS THE PASS ID ${businessIdController.text}');
                          if (value != false) {
                            Get.put(NotificationController());
                            Get.put(RewardController());
                            // You might need to modify `signUp` to return a success indicator
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VerificationPendingView()));
                            homeController.setImageNull();
                            homeController.clearLogo();
                          }

                          context.loaderOverlay
                              .hide(); // Hide loader whether signup is successful or not
                        });
                      }
                    },
                    text: "SWIPE TO SIGNUP",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getAndFill() async {
    if (await LocationPermissionManager().requestLocationPermission(context)) {
      latLng = await homeServices.getCurrentLocation(context: context);
      final currentLocation =
          await homeServices.getAddress(latLng ?? const LatLng(0, 0));
      await addingAddress(currentLocation ?? const Placemark());
      businessAddressController.text =
          "${currentLocation?.street} , ${currentLocation?.locality} , ${currentLocation?.administrativeArea} , ${currentLocation?.country}";
    }
  }

  Future<void> addingAddress(Placemark currentAddress) async {
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
      latitude: getDoubleAsync(SharedPrefKey.latitude),
      longitude: getDoubleAsync(SharedPrefKey.longitude),
    );
    log(address!.completeAddress.toString());
    log("CURRENT ADDRESS MODEL>>>>>>>>>>>>>>>>>>>>>>>>. ${address!.country}");
  }
}
