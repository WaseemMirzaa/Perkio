import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/add_deals_controller.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/widgets/auth_components/authComponents.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class AddDeals extends StatefulWidget {
  const AddDeals({super.key});

  @override
  State<AddDeals> createState() => _AddDealsState();
}

class _AddDealsState extends State<AddDeals> {
  final AddDealsController myController = Get.find<AddDealsController>();

  final BusinessController controller = Get.find<BusinessController>();

  final homeController = Get.put(HomeController(HomeServices()));

  FocusNode nameNode = FocusNode();

  FocusNode companyNode = FocusNode();

  FocusNode addressNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: LoaderOverlay(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(15.40.h), // Adjust height to match first bar
            child: SizedBox(
              height: 15.40.h,
              child: PreferredSize(
                preferredSize: Size.fromHeight(12.h),
                child: Obx(() {
                  // Use Obx to react to changes in userProfile
                  if (userController.businessProfile.value == null) {
                    return customAppBar(
                      userName: 'Loading...', // Placeholder text
                      userLocation: 'Loading...',
                      isNotification: false,
                      isChangeBusinessLocation: true,
                    );
                  }

                  // Use the data from the observable
                  final user = userController.businessProfile.value!;
                  final userName = user.userName ?? 'Unknown';
                  final userLocation = user.address ?? 'No Address';
                  final latLog = user.latLong;
                  final image = user.image;

                  return customAppBar(
                      userName: userName,
                      isNotification: false,
                      latitude: latLog?.latitude ?? 0.0,
                      longitude: latLog?.longitude ?? 0.0,
                      userLocation: userLocation,
                      isChangeBusinessLocation: true,
                      userImage: image);
                }),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerBoxVertical(height: 10),
                  Center(
                      child: Text(
                    TempLanguage.txtAddDetails,
                    style: poppinsMedium(fontSize: 14),
                  )),
                  const SpacerBoxVertical(height: 20),
                  Text(
                    'Deal Name',
                    style: poppinsRegular(fontSize: 13),
                  ),
                  const SpacerBoxVertical(height: 10),
                  TextFieldWidget(
                    text: 'Deal Name',
                    textController: myController.dealNameController,
                    focusNode: nameNode,
                    onEditComplete: () =>
                        focusChange(context, nameNode, companyNode),
                  ),
                  const SpacerBoxVertical(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TempLanguage.txtUses,
                              style: poppinsRegular(fontSize: 13),
                            ),
                            const SpacerBoxVertical(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    myController.decreaseCounter();
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.whiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3))
                                        ]),
                                    child: Center(
                                        child: Text(
                                      '-',
                                      style: poppinsRegular(fontSize: 18),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Obx(() {
                                    return Text(
                                      "${myController.counter.value}",
                                      style: poppinsRegular(fontSize: 17),
                                    );
                                  }),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    myController.increaseCounter();
                                    print(
                                        myController.counter.value.toString());
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.whiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3))
                                        ]),
                                    child: Center(
                                        child: Text(
                                      '+',
                                      style: poppinsRegular(fontSize: 18),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SpacerBoxVertical(height: 20),
                  Text(
                    'Deal Photo',
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
                  SpacerBoxVertical(height: 10.h),
                  ButtonWidget(
                      onSwipe: () async {
                        if (myController
                            .dealNameController.text.isEmptyOrNull) {
                          showSnackBar(
                              'Empty Fields', 'Name field is required');
                        } else if (homeController.pickedImage == null) {
                          showSnackBar(
                              'Empty Fields', 'Deal logo field is required');
                        } else if (myController.counter.value <= 0) {
                          showSnackBar(
                              'Empty Fields', 'Please set the number of uses');
                        } else {
                          context.loaderOverlay.show(
                            widgetBuilder: (context) =>
                                Center(child: circularProgressBar()),
                          );
                          final imageLink = await homeController
                              .uploadImageToFirebaseWithCustomPath(
                                  homeController.pickedImage!.path,
                                  'Deals/${DateTime.now().toIso8601String()}');
                          print("Link Is: $imageLink");
                          DealModel dealModel = DealModel(
                              dealName: myController.dealNameController.text
                                  .toLowerCase(),
                              companyName:
                                  getStringAsync(SharedPrefKey.userName),
                              location: getStringAsync(SharedPrefKey.address),
                              uses: myController.counter.value,
                              businessId: getStringAsync(SharedPrefKey.uid),
                              image: imageLink,
                              // ignore: unnecessary_null_comparison
                              longLat: getDoubleAsync(SharedPrefKey.latitude) !=
                                      null
                                  ? GeoPoint(
                                      getDoubleAsync(SharedPrefKey.latitude),
                                      getDoubleAsync(SharedPrefKey.longitude))
                                  : null,
                              createdAt: Timestamp.now(),
                              isPromotionStar: false);
                          print(dealModel.longLat);
                          print(dealModel.uses.toString());
                          log(dealModel.businessId!);
                          await controller.addDeal(dealModel).then((value) {
                            myController.clearTextFields();
                            homeController.setImageNull();
                            context.loaderOverlay.hide();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomBarView(isUser: false)),
                                (route) => false);
                          });
                        }
                      },
                      text: TempLanguage.btnLblSwipeToAdd),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}
