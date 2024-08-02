import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/ui_controllers/add_deals_controller.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
import 'package:skhickens_app/controllers/home_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/services/home_services.dart';
import 'package:skhickens_app/widgets/auth_components/authComponents.dart';
import 'package:skhickens_app/widgets/auth_textfield.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/common_text_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/snackbar_widget.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class AddDeals extends StatelessWidget {
   AddDeals({super.key});

  final AddDealsController myController = Get.find<AddDealsController>();

  final BusinessController controller = Get.find<BusinessController>();
  final homeController = Get.put(HomeController(HomeServices()));

   FocusNode nameNode = FocusNode();
   FocusNode companyNode = FocusNode();
   FocusNode addressNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(12.h),child: customAppBar(),),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerBoxVertical(height: 10),
              Center(child: Text(TempLanguage.txtAddDetails, style: poppinsMedium(fontSize: 14),)),
              const SpacerBoxVertical(height: 20),
              Text('Deal Name', style: poppinsRegular(fontSize: 13),),
              const SpacerBoxVertical(height: 10),
              TextFieldWidget(text: 'Deal Name',textController: myController.dealNameController,focusNode: nameNode,onEditComplete: ()=>focusChange(context, nameNode, companyNode),),
              const SpacerBoxVertical(height: 20),

              Text('Company Name', style: poppinsRegular(fontSize: 13),),
              const SpacerBoxVertical(height: 10),
              TextFieldWidget(text: 'Company Name',textController: myController.companyNameController,focusNode: companyNode,onEditComplete: ()=>focusChange(context, companyNode, addressNode),),
              const SpacerBoxVertical(height: 20),


              Text("Address", style: poppinsRegular(fontSize: 13),),
              const SpacerBoxVertical(height: 10),
              TextFieldWidget(text: 'Address',textController: myController.addressController,focusNode: addressNode,onEditComplete: ()=>unFocusChange(context),),
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
              Text('Deal Logo', style: poppinsRegular(fontSize: 13),),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Obx(()=> Stack(
                          clipBehavior: Clip.none,
                            children: [
                              uploadImageComp(homeController.pickedImage, (){
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
                      const SpacerBoxVertical(height: 10),
              Obx(()=> controller.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ButtonWidget(onSwipe: ()async{
                    if(myController.dealNameController.text.isEmptyOrNull){
                      showSnackBar('Empty Fields','Name field is required');
                    }else if(myController.companyNameController.text.isEmptyOrNull){
                      showSnackBar('Empty Fields','Company name field is required');
                    }else if(myController.addressController.text.isEmptyOrNull){
                      showSnackBar('Empty Fields','Address is required');
                    }else if(homeController.pickedImage!.path.isEmptyOrNull){
                      showSnackBar('Empty Fields','Deal logo field is required');
                    }
                    final imageLink = await homeController.uploadImageToFirebaseWithCustomPath(homeController.pickedImage!.path, 'Deals/${DateTime.now().toIso8601String()}');
                    print("Link Is: $imageLink");
                    DealModel dealModel = DealModel(dealName: myController.dealNameController.text, restaurantName: myController.companyNameController.text,location: myController.addressController.text ,uses: myController.counter.value.toString(),businessId: getStringAsync(SharedPrefKey.uid) ,image: imageLink);
                    final isDealDone = await controller.addDeal(dealModel);
                    isDealDone ? Get.back() : null;
              }, text: TempLanguage.btnLblSwipeToAdd),),
            ],
          ),
        ),
      ),
    );
  }
}