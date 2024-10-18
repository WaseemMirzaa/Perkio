import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/add_deals_controller.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/widgets/auth_components/authComponents.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class EditMyDeals extends StatefulWidget {
  EditMyDeals({super.key, required this.dealModel});
  DealModel dealModel;

  @override
  State<EditMyDeals> createState() => _EditMyDealsState();
}

class _EditMyDealsState extends State<EditMyDeals> {
  final AddDealsController myController = Get.find<AddDealsController>();

  final BusinessController controller = Get.find<BusinessController>();

  final homeController = Get.put(HomeController(HomeServices()));

  FocusNode nameNode = FocusNode();

  FocusNode companyNode = FocusNode();

  FocusNode addressNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController.dealNameController.text =
        widget.dealModel.dealName.capitalizeEachWord();
    myController.counter.value = widget.dealModel.uses!;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(15.40.h), // Adjust height to match first bar
          child: SizedBox(
            height: 15.40.h,
            child: PreferredSize(
              preferredSize: Size.fromHeight(12.h),
              child: customAppBar(
                isNotification: false,
                userName: 'Loading...', // Placeholder text
                userLocation: 'Loading...',
                isChangeBusinessLocation: true,
              ),
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
                  'Edit Deal Details',
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
                  'Deal Logo',
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
                        homeController.pickedImage != null
                            ? uploadImageComp(homeController.pickedImage, () {
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
                              })
                            : networkImageComp(widget.dealModel.image, () {
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
                Obx(
                  () => controller.loading.value
                      ? Center(child: circularProgressBar())
                      : ButtonWidget(
                          onSwipe: () async {
                            if (myController
                                .dealNameController.text.isEmptyOrNull) {
                              showSnackBar(
                                  'Empty Fields', 'Name field is required');
                            } else if (homeController.pickedImage == null &&
                                widget.dealModel.image.isEmptyOrNull) {
                              showSnackBar(
                                  'Deal Logo', 'Deal Logo is required');
                            } else if (myController.counter.value <= 0) {
                              showSnackBar('Empty Fields',
                                  'Please set the number of uses');
                            } else {
                              context.loaderOverlay.show(
                                widgetBuilder: (context) =>
                                    Center(child: circularProgressBar()),
                              );
                              final imageLink = homeController.pickedImage ==
                                      null
                                  ? null
                                  : await homeController
                                      .uploadImageToFirebaseWithCustomPath(
                                          homeController.pickedImage!.path,
                                          'Deals/${DateTime.now().toIso8601String()}');
                              print("Link Is: $imageLink");
                              widget.dealModel.dealName = myController
                                  .dealNameController.text
                                  .toLowerCase();
                              widget.dealModel.uses =
                                  myController.counter.value;
                              widget.dealModel.image = imageLink.isEmptyOrNull
                                  ? widget.dealModel.image
                                  : imageLink;

                              // widget.dealModel.location =
                              //     userController.userProfile.value!.address;
                              // widget.dealModel.longLat =
                              //     userController.userProfile.value!.latLong;

                              print(
                                  '------------ + ${widget.dealModel.location}');

                              await controller
                                  .editMyDeal(widget.dealModel)
                                  .then((value) {
                                context.loaderOverlay.hide();
                                myController.clearTextFields();
                                homeController.setImageNull();
                                Get.back();
                              });
                              context.loaderOverlay.hide();
                            }
                          },
                          text: 'SWIPE TO EDIT DEAL'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
