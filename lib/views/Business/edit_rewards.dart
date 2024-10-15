import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/controllers/ui_controllers/add_rewards_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/widgets/auth_components/authComponents.dart';
import 'package:swipe_app/widgets/auth_textfield.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/snackbar_widget.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class EditMyRewards extends StatefulWidget {
  EditMyRewards({super.key, required this.rewardModel});
  RewardModel rewardModel;

  @override
  State<EditMyRewards> createState() => _EditMyRewardsState();
}

class _EditMyRewardsState extends State<EditMyRewards> {
  final AddRewardsController myController = Get.find<AddRewardsController>();

  final BusinessController controller = Get.find<BusinessController>();

  final homeController = Get.put(HomeController(HomeServices()));

  FocusNode rewardNameNode = FocusNode();
  FocusNode pointsToRedeemNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myController.rewardNameController.text = widget.rewardModel.rewardName!;
    myController.pointsToRedeemController.text =
        widget.rewardModel.pointsToRedeem.toString();
    myController.counter.value = widget.rewardModel.uses ?? 0;
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
              child: Obx(() {
                // Use Obx to react to changes in userProfile
                if (userController.userProfile.value == null) {
                  return customAppBar(
                    isNotification: false,
                    userName: 'Loading...', // Placeholder text
                    userLocation: 'Loading...',
                    isChangeBusinessLocation: true,
                  );
                }

                // Use the data from the observable
                final user = userController.userProfile.value!;
                final userName = user.userName ?? 'Unknown';
                final userLocation = user.address ?? 'No Address';
                final latLog = user.latLong;

                return customAppBar(
                  userName: userName,
                  isNotification: false,
                  latitude: latLog?.latitude ?? 0.0,
                  longitude: latLog?.longitude ?? 0.0,
                  userLocation: userLocation,
                  isChangeBusinessLocation: true,
                );
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
                  'Edit Reward Detail',
                  style: poppinsMedium(fontSize: 14),
                )),
                const SpacerBoxVertical(height: 20),
                Text(
                  'Reward Name',
                  style: poppinsRegular(fontSize: 13),
                ),
                const SpacerBoxVertical(height: 10),
                TextFieldWidget(
                  text: 'Reward Name',
                  textController: myController.rewardNameController,
                  focusNode: rewardNameNode,
                  onEditComplete: () =>
                      focusChange(context, rewardNameNode, pointsToRedeemNode),
                ),
                const SpacerBoxVertical(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Points to Redeem',
                      style: poppinsRegular(fontSize: 13),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text('PPS (Points Per Scan): ${controller.pps}'))
                  ],
                ),
                const SpacerBoxVertical(height: 10),
                TextFieldWidget(
                  text: 'Points',
                  textController: myController.pointsToRedeemController,
                  keyboardType: TextInputType.number,
                  focusNode: pointsToRedeemNode,
                  onEditComplete: () => unFocusChange(context),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onSubmit: (value) {
                    int userInput = int.parse(value);
                    if (userInput % controller.pps.value! == 0) {
                    } else {
                      showSnackBar('Invalid Input',
                          'Please enter a number that is a multiple of ${controller.pps.value}.');
                    }
                  },
                ),
                const SpacerBoxVertical(height: 5),
                const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Note: Points to Redeem must be multiple of the PPS (Points Per Scan)')),
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
                  'Reward Logo',
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
                            : networkImageComp(widget.rewardModel.rewardLogo,
                                () {
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
                            int points = int.parse(
                                myController.pointsToRedeemController.text);
                            if (myController
                                .rewardNameController.text.isEmptyOrNull) {
                              showSnackBar('Empty Fields',
                                  'Please enter the reward name');
                            } else if (myController
                                .pointsToRedeemController.text.isEmptyOrNull) {
                              showSnackBar('Empty Fields',
                                  'Please enter the points to redeem (PTR)');
                            } else if (homeController.pickedImage == null &&
                                widget.rewardModel.rewardLogo.isEmptyOrNull) {
                              showSnackBar('Empty Fields',
                                  'Please upload the reward logo');
                            } else if (myController.counter.value <= 0) {
                              showSnackBar('Empty Fields',
                                  'Please set the number of uses');
                            } else if (points % controller.pps.value! != 0) {
                              showSnackBar('Invalid Input',
                                  'Please enter a number that is a multiple of pps: ${controller.pps.value}.');
                            } else {
                              int userInput = int.parse(
                                  myController.pointsToRedeemController.text);
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
                              widget.rewardModel.rewardName =
                                  myController.rewardNameController.text;
                              widget.rewardModel.uses =
                                  myController.counter.value;
                              widget.rewardModel.pointsToRedeem = userInput;
                              widget.rewardModel.rewardLogo =
                                  imageLink.isEmptyOrNull
                                      ? widget.rewardModel.rewardLogo
                                      : imageLink;

                              widget.rewardModel.rewardAddress =
                                  userController.userProfile.value!.address;
                              widget.rewardModel.latLong =
                                  userController.userProfile.value!.latLong;

                              print(
                                  '------------ + ${widget.rewardModel.rewardAddress}');

                              final isDealDone = await controller
                                  .editMyRewards(widget.rewardModel)
                                  .then((value) {
                                context.loaderOverlay.hide();
                                myController.clearTextFields();
                                homeController.setImageNull();
                                Get.back();
                                context.loaderOverlay.hide();
                              });
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
