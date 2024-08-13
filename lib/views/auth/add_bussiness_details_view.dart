import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/home_controller.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/modals/user_modal.dart';
import 'package:skhickens_app/services/home_services.dart';
import 'package:skhickens_app/services/user_services.dart';
import 'package:skhickens_app/views/Business/verification_pending_view.dart';
import 'package:skhickens_app/widgets/auth_components/authComponents.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/common_text_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/primary_layout_widget/secondary_layout.dart';
import '../../widgets/snackbar_widget.dart' as X;


class AddBusinessDetailsView extends StatelessWidget {
  AddBusinessDetailsView({super.key,required this.userModel});
  UserModel userModel;
  final businessIdController = TextEditingController();
  final businessAddressController = TextEditingController();
  final websiteController = TextEditingController();

  final homeController = Get.put(HomeController(HomeServices()));
  final userController = Get.put(UserController(UserServices()));

  final businessAddressNode = FocusNode();
  final websiteNode = FocusNode();
  final businessIDNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SecondaryLayoutWidget(
        header: Stack(children: [
          CustomShapeContainer(height: 22.h,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxVertical(height: 40),
                BackButtonWidget(padding: EdgeInsets.zero,),
                Center(child: Text('Add Business Info', style: poppinsMedium(fontSize: 25),))
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
                SizedBox(height: 21.h,),

                Text('Business Address', style: poppinsRegular(fontSize: 13),),
                const SpacerBoxVertical(height: 10),
                TextFieldWidget(text: 'Business Address',textController: businessAddressController,focusNode: businessAddressNode,onEditComplete: ()=> focusChange(context, businessAddressNode, websiteNode),),
                const SpacerBoxVertical(height: 20),
                Text('Website', style: poppinsRegular(fontSize: 13),),
                const SpacerBoxVertical(height: 10),
                TextFieldWidget(text: 'Website',textController: websiteController,focusNode: websiteNode, onEditComplete: ()=> focusChange(context, websiteNode, businessIDNode),),
                const SpacerBoxVertical(height: 20),
                Text('Google Business ID', style: poppinsRegular(fontSize: 13),),
                const SpacerBoxVertical(height: 10),
                TextFieldWidget(text: 'Google Business ID',textController: businessIdController,focusNode: businessIDNode,onEditComplete: ()=>unFocusChange(context),),
                const SpacerBoxVertical(height: 20),

                Text('Logo', style: poppinsRegular(fontSize: 13),),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Obx(()=> Stack(
                    clipBehavior: Clip.none,
                    children: [
                      uploadImageComp(homeController.pickedImage2,(){
                        showAdaptiveDialog(context: context, builder: (context)=>  imageDialog(
                            galleryTap:(){
                              Get.back();
                              homeController.pickImageFromGallery(isCropActive: false,isLogo: true);
                            },
                            cameraTap: (){
                              Get.back();
                              homeController.pickImageFromCamera(isCropActive: false, isLogo: true);
                            })
                        );
                      }),
                      Positioned(
                          top: -1.h,
                          right: -0.8.h,
                          child: IconButton(
                            iconSize: 18.sp,
                            onPressed: (){
                              homeController.clearLogo();
                            },icon: const Icon(
                            Icons.close_rounded,
                          ),)
                      )
                    ],
                  ),
                  ),
                ),
                const SizedBox(height: 20,),
                Text('Business Images', style: poppinsRegular(fontSize: 13),),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Obx(()=> Stack(
                    clipBehavior: Clip.none,
                    children: [
                      uploadImageComp(homeController.pickedImage,(){
                        showAdaptiveDialog(context: context, builder: (context)=>  imageDialog(
                            galleryTap:(){
                              Get.back();
                              homeController.pickImageFromGallery(isCropActive: false);
                            },
                            cameraTap: (){
                              Get.back();
                              homeController.pickImageFromCamera(isCropActive: false);
                            })
                        );
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
                SpacerBoxVertical(height: 3.h),
                ButtonWidget(onSwipe: ()async{
                  print("The LOGO is: ${homeController.pickedImage2?.path} \n and \n The Business Image is ${homeController.pickedImage?.path}");
                  if(businessAddressController.text.isEmptyOrNull){
                    X.showSnackBar('Fields Required', 'Please enter the business address');
                  } else if(websiteController.text.isEmptyOrNull){
                    X.showSnackBar('Fields Required', 'Please enter the website');
                  }else if(businessIdController.text.isEmptyOrNull){
                    X.showSnackBar('Fields Required', 'Please enter the Google Business ID');
                  }else if(homeController.pickedImage2 == null){
                    X.showSnackBar('Fields Required', 'Please upload the business Logo');
                  }else if(homeController.pickedImage == null){
                    X.showSnackBar('Fields Required', 'Please upload the business image');
                  } else {
                    context.loaderOverlay.show();
                    userModel.address = businessAddressController.text;
                    userModel.website = websiteController.text;
                    userModel.businessId = businessIdController.text;
                    if(getStringAsync(SharedPrefKey.role) == SharedPrefKey.business){
                      userModel.image = homeController.pickedImage?.path;
                      userModel.logo = homeController.pickedImage2?.path;
                    }
                    await userController.signUp(userModel).then((value){
                      Get.to(()=> VerificationPendingView());
                      homeController.setImageNull();
                      homeController.clearLogo();
                      context.loaderOverlay.hide();
                    });

                  }
                  // Navigator.pushNamedAndRemoveUntil(context,AppRoutes.bottomBarView,(route)=>false);
                }, text: "SWIPE TO SIGNUP")
              ],
            ),
          ),
        ),
      ),

      );
  }
}