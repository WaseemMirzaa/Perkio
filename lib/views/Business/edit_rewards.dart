import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/ui_controllers/add_deals_controller.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
import 'package:skhickens_app/controllers/home_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/modals/reward_modal.dart';
import 'package:skhickens_app/services/home_services.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/widgets/auth_components/authComponents.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/snackbar_widget.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class EditMyRewards extends StatefulWidget {
  EditMyRewards({super.key,required this.rewardModel});
  RewardModel rewardModel;

  @override
  State<EditMyRewards> createState() => _EditMyRewardsState();
}

class _EditMyRewardsState extends State<EditMyRewards> {
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
    myController.dealNameController.text = widget.rewardModel.rewardName!;
    myController.companyNameController.text = widget.rewardModel.companyName!;
    myController.addressController.text = widget.rewardModel.rewardAddress!;
    myController.counter.value = widget.rewardModel.uses ?? 0;
  }

  @override
  Widget build(BuildContext context) {

    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight(12.h),child: customAppBar(),),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxVertical(height: 10),
                Center(child: Text('Reward Detail', style: poppinsMedium(fontSize: 14),)),
                const SpacerBoxVertical(height: 20),
                Text('Reward Name', style: poppinsRegular(fontSize: 13),),
                const SpacerBoxVertical(height: 10),
                TextFieldWidget(text: 'Reward Name',textController: myController.dealNameController,focusNode: nameNode,onEditComplete: ()=>focusChange(context, nameNode, companyNode),),
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
                                onTap: (){
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
                                child: Obx((){
                                  return Text( "${myController.counter.value}", style: poppinsRegular(fontSize: 17),);
                                }),
                              ),

                              GestureDetector(
                                onTap: (){
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
                const SpacerBoxVertical(height: 20),
                Text('Reward Logo', style: poppinsRegular(fontSize: 13),),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Obx(()=> Stack(
                    clipBehavior: Clip.none,
                    children: [
                      homeController.pickedImage != null ? uploadImageComp(homeController.pickedImage, (){
                        showAdaptiveDialog(context: context, builder: (context)=>imageDialog(galleryTap: (){
                          Get.back();
                          homeController.pickImageFromGallery(isCropActive: false);
                        }, cameraTap: (){
                          Get.back();
                          homeController.pickImageFromCamera(isCropActive: false);
                        }));
                      }) : networkImageComp(widget.rewardModel.rewardLogo, (){
                        showAdaptiveDialog(context: context, builder: (context)=>imageDialog(galleryTap: (){
                          Get.back();
                          homeController.pickImageFromGallery(isCropActive: false);
                        }, cameraTap: (){
                          Get.back();
                          homeController.pickImageFromCamera(isCropActive: false);
                        }));
                      }),
                      Positioned(
                          top: -1.h,
                          right: -0.8.h,
                          child: IconButton(
                            iconSize: 18.sp,
                            onPressed: (){
                              homeController.setImageNull();
                            },icon: const Icon(
                            Icons.close_rounded,
                          ),)
                      )
                    ],
                  ),
                  ),
                ),
                const SpacerBoxVertical(height: 30),
                Obx(()=> controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ButtonWidget(onSwipe: ()async{
                  if(myController.dealNameController.text.isEmptyOrNull){
                    showSnackBar('Empty Fields','Name field is required');
                  }else{
                  context.loaderOverlay.show();
                  final imageLink = homeController.pickedImage == null ? null : await homeController.uploadImageToFirebaseWithCustomPath(homeController.pickedImage!.path, 'Deals/${DateTime.now().toIso8601String()}');
                  print("Link Is: $imageLink");
                  widget.rewardModel.rewardName = myController.dealNameController.text;
                  widget.rewardModel.uses = myController.counter.value;
                  widget.rewardModel.rewardLogo = imageLink.isEmptyOrNull ? widget.rewardModel.rewardLogo : imageLink;

                  final isDealDone = await controller.editMyRewards(widget.rewardModel).then((value) {
                    context.loaderOverlay.hide();
                    myController.clearTextFields();
                    homeController.setImageNull();
                    Get.back();
                    // Get.offAll(()=> BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false));
                    context.loaderOverlay.hide();
                  });
                }}, text: 'SWIPE TO EDIT DEAL'),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}