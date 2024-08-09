import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/controllers/home_controller.dart';
import 'package:skhickens_app/controllers/ui_controllers/add_rewards_controller.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/modals/reward_modal.dart';
import 'package:skhickens_app/services/home_services.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/common_text_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:skhickens_app/widgets/snackbar_widget.dart';

class AddRewards extends StatefulWidget {
  const AddRewards({super.key});

  @override
  State<AddRewards> createState() => _AddRewardsState();
}

class _AddRewardsState extends State<AddRewards> {
  final AddRewardsController myController = Get.find<AddRewardsController>();
  final BusinessController controller = Get.find<BusinessController>();
  final homeController = Get.put(HomeController(HomeServices()));


  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight(12.h), child: customAppBar(),),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxVertical(height: 10),
                Center(child: Text("Rewards Details", style: poppinsMedium(fontSize: 14),)),
                const SpacerBoxVertical(height: 20),

                Text('Rewards Name', style: poppinsRegular(fontSize: 13)),
                const SpacerBoxVertical(height: 10),
                CommonTextField(text: TempLanguage.txtSuperDuper,
                  textController: myController.dealNameController,),
                const SpacerBoxVertical(height: 20),

                Text(TempLanguage.txtRequiredPointsToRedeem, style: poppinsRegular(fontSize: 13),),
                const SpacerBoxVertical(height: 10),
                CommonTextField(
                  text: 'Points', textController: myController.pointsToRedeemController,),
                const SpacerBoxVertical(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TempLanguage.txtUses, style: poppinsRegular(fontSize: 13),),
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
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3)
                                        )
                                      ]
                                  ),
                                  child: Center(
                                      child: Text('-', style: poppinsRegular(fontSize: 18),)
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Obx(() {
                                  return Text("${myController.counter.value}",
                                    style: poppinsRegular(fontSize: 17),);
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
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3)
                                        )
                                      ]
                                  ),
                                  child: Center(
                                      child: Text('+', style: poppinsRegular(fontSize: 18),)
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15,),

                Text('Deal Logo', style: poppinsRegular(fontSize: 13),),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Obx(() =>
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          uploadImageComp(homeController.pickedImage, () {
                            showAdaptiveDialog(context: context, builder: (context) =>
                                imageDialog(galleryTap: () {
                                  Get.back();
                                  homeController.pickImageFromGallery(isCropActive: false);
                                }, cameraTap: () {
                                  Get.back();
                                  homeController.pickImageFromCamera(isCropActive: false);
                                }));
                          }),
                          Positioned(
                              top: -1.h,
                              right: -0.8.h,
                              child: IconButton(
                                iconSize: 18.sp,
                                onPressed: () {
                                  homeController.setImageNull();
                                }, icon: const Icon(
                                Icons.close_rounded,
                              ),)
                          )
                        ],
                      ),
                  ),
                ),

                const SpacerBoxVertical(height: 50),
                ButtonWidget(onSwipe: () async {
                  if (myController.dealNameController.text.isEmptyOrNull) {
                    showSnackBar('Empty Fields', 'Name field is required');
                  } else if((myController.pointsToRedeemController.text.isEmptyOrNull)){
                    showSnackBar('Empty Fields', 'Points to redeem field is ');
                  } else if (homeController.pickedImage == null) {
                    showSnackBar('Empty Fields', 'Deal logo field is required');
                  }else {
                    context.loaderOverlay.show();
                    final imageLink = await homeController.uploadImageToFirebaseWithCustomPath(
                        homeController.pickedImage!.path,
                        'Rewards/${DateTime.now().toIso8601String()}');
                    print("Link Is: $imageLink");
                    RewardModel rewardModel = RewardModel(
                        rewardName: myController.dealNameController.text,
                        companyName: getStringAsync(SharedPrefKey.userName),
                        rewardAddress: getStringAsync(SharedPrefKey.address),
                        businessId: getStringAsync(SharedPrefKey.uid),
                        rewardLogo: imageLink,
                        pointsToRedeem: myController.pointsToRedeemController.text.toInt(),
                        uses: myController.counter.value,
                        createdAt: Timestamp.now());
                    final isDealDone = await controller.addReward(rewardModel).then((value) {
                      myController.clearTextFields();
                      homeController.setImageNull();
                      context.loaderOverlay.hide();
                      Get.offAll(() =>
                          BottomBarView(
                              isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user
                                  ? true
                                  : false));
                    });
                    context.loaderOverlay.hide();
                  }
                }, text: TempLanguage.btnLblSwipeToAdd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}