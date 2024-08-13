import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:skhickens_app/widgets/auth_components/authComponents.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/common_space.dart';
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
  final rewardNameNode = FocusNode();
  final pointsToRedeemNode = FocusNode();

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
                TextFieldWidget(text: TempLanguage.txtSuperDuper,
                  textController: myController.rewardNameController,focusNode: rewardNameNode, onEditComplete: ()=>focusChange(context, rewardNameNode, pointsToRedeemNode),),
                const SpacerBoxVertical(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Points to Redeem', style: poppinsRegular(fontSize: 13),),
                    Align(alignment: Alignment.centerRight, child: Text('PPS (Points Per Scan): ${controller.pps}'))
                  ],
                ),
                const SpacerBoxVertical(height: 10),
                TextFieldWidget(
                  text: 'Points', textController: myController.pointsToRedeemController,keyboardType: TextInputType.number,focusNode: pointsToRedeemNode, onEditComplete: ()=>unFocusChange(context),inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onSubmit: (value){
                  int userInput = int.parse(value);
                  if (userInput % controller.pps.value! == 0) {

                  } else {
                    showSnackBar('Invalid Input', 'Please enter a number that is a multiple of ${controller.pps.value}.');
                  }
                },
                ),
                const SpacerBoxVertical(height: 5),

                const Align(alignment: Alignment.centerRight,child: Text('Note: Points to Redeem must be multiple of the PPS (Points Per Scan)')),

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

                Text('Reward  Logo', style: poppinsRegular(fontSize: 13),),
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
                  int points = int.parse(myController.pointsToRedeemController.text);
                  if (myController.rewardNameController.text.isEmptyOrNull) {
                    showSnackBar('Empty Fields', 'Please enter the reward name');
                  } else if((myController.pointsToRedeemController.text.isEmptyOrNull)){
                    showSnackBar('Empty Fields', 'Please enter the points to redeem (PTR)');
                  } else if (homeController.pickedImage == null) {
                    showSnackBar('Empty Fields', 'Please upload the reward logo');
                  } else if (points % controller.pps.value! != 0) {
                    showSnackBar('Invalid Input', 'Please enter a number that is a multiple of pps: ${controller.pps.value}.');
                  }else {
                    context.loaderOverlay.show();
                    final imageLink = await homeController.uploadImageToFirebaseWithCustomPath(
                        homeController.pickedImage!.path,
                        'Rewards/${DateTime.now().toIso8601String()}');
                    print("Link Is: $imageLink");
                    RewardModel rewardModel = RewardModel(
                        rewardName: myController.rewardNameController.text,
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
                      Navigator.pop(context);
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