import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/home_controller.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/modals/user_modal.dart';
import 'package:skhickens_app/services/home_services.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/profile_list_items.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/snackbar_widget.dart' as X;

class ProfileSettingsBusiness extends StatefulWidget {
  const ProfileSettingsBusiness({super.key});

  @override
  State<ProfileSettingsBusiness> createState() => _ProfileSettingsBusinessState();
}

class _ProfileSettingsBusinessState extends State<ProfileSettingsBusiness> {

  var controller = Get.find<UserController>();
  late StreamController<UserModel> _userProfileStreamController;
  late UserModel? businessProfile;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController businessIdController = TextEditingController();
  RxBool enabled = false.obs;

  final HomeController homeController = Get.put(HomeController(HomeServices()));

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
    businessProfile = await controller.getUser(getStringAsync(SharedPrefKey.uid));
    _userProfileStreamController.add(businessProfile!);
    userNameController.text = businessProfile?.userName ?? 'Not Set';
    emailController.text = businessProfile?.email ?? 'Not Set';
    phoneNoController.text = businessProfile?.phoneNo ?? 'Not Set';
    addressController.text = businessProfile?.address ?? 'Not Set';
    websiteController.text = businessProfile?.website ?? 'Not Set';
    businessIdController.text = businessProfile?.businessId ?? 'Not Set';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: StreamBuilder<UserModel>(
        stream: _userProfileStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }
          final businessProfile = snapshot.data!;
          return Column(
              children: [
                Stack(
                  children: [
                    Obx(() {
                      return (homeController.pickedImage != null)
                          ? Image.file(homeController.pickedImage!,height: 30.h,width: 100.w,fit: BoxFit.fill,)
                          : !getStringAsync(SharedPrefKey.photo).isEmptyOrNull ? Image.network(getStringAsync(SharedPrefKey.photo),height: 30.h,width: 100.w,fit: BoxFit.fill,) :  Image.asset(AppAssets.imageHeader,fit: BoxFit.fill,height: 30.h,width: 100.w,);
                    }),
                    BackButtonWidget(),
                    Positioned(
                      right: 3.w,
                      top: 6.h,
                      child: GestureDetector(
                        onTap: () {
                          showAdaptiveDialog(context: context, builder: (context)=> AlertDialog(
                            title: Text('Pick Image',style: poppinsBold(fontSize: 15),),
                            content: const Text('Upload profile from gallery or catch with Camera'),
                            actions: [
                              IconButton(onPressed: ()async{
                                Get.back();
                                await homeController.pickImageFromGallery().then((value)async{
                                  String? path = await homeController.uploadImageToFirebaseOnID(homeController.pickedImage?.path ?? '', getStringAsync(SharedPrefKey.uid));
                                  if(!path.isEmptyOrNull){
                                    homeController.updateCollection(getStringAsync(SharedPrefKey.uid), 'users',
                                        {
                                          UserKey.IMAGE: path
                                        });
                                  }
                                });
                              }, icon: const Icon(Icons.drive_file_move_outline)),
                              IconButton(onPressed: ()async{
                                Get.back();
                                await homeController.pickImageFromCamera().then((value)async{
                                 String? path = await homeController.uploadImageToFirebaseOnID(homeController.pickedImage?.path ?? '', getStringAsync(SharedPrefKey.uid));
                                 print("The path is: === $path");
                                 if(!path.isEmptyOrNull){
                                   print("DB called");
                                   homeController.updateCollection(getStringAsync(SharedPrefKey.uid), 'users',
                                       {
                                         UserKey.IMAGE: path
                                       });
                                 }
                                  });
                              }, icon: const Icon(Icons.camera_alt_outlined)),
                            ],
                          ));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                                color: AppColors.whiteColor,
                                shape: BoxShape.circle
                            ), child: Icon(Icons.edit, size: 20.sp,)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h,),
                Obx(() {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: GestureDetector(
                          onTap: () async {
                            if (enabled.value) {
                              bool success = await homeController.updateCollection(getStringAsync(SharedPrefKey.uid), CollectionsKey.USERS,{
                                UserKey.USERNAME: userNameController.text,
                                UserKey.EMAIL: emailController.text,
                                UserKey.PHONENO: phoneNoController.text,
                                UserKey.ADDRESS: addressController.text,
                                UserKey.WEBSITE: websiteController.text,
                                UserKey.BUSINESSID: businessIdController.text
                              });
                              if (success) {
                                X.showSnackBar(
                                    'Success', 'User data updated successfully!');
                                enabled.value = false;
                              } else {
                                X.showSnackBar('Error', 'Failed to update user data.',);
                              }
                            } else {
                              enabled.value = true;
                            }
                          },
                          child: Text(
                            !enabled.value ? TempLanguage.txtEdit : 'Save',
                            style: poppinsRegular(fontSize: 10, color: AppColors
                                .hintText),)),
                    ),
                  );
                }),
                Expanded(
                  child: Obx(()=> ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                      children: [
                        ProfileListItems(path: AppAssets.profile1,
                          textController: userNameController,
                          enabled: enabled.value,),
                        const SizedBox(height: 10,),
                        ProfileListItems(path: AppAssets.profile2,
                          textController: phoneNoController,
                          enabled: enabled.value,),
                        const SizedBox(height: 10,),
                        ProfileListItems(path: AppAssets.profile3,
                          textController: emailController,),
                        const SizedBox(height: 10,),

                        ProfileListItems(path: AppAssets.profile4,
                          textController: addressController,
                          enabled: enabled.value,),
                        const SizedBox(height: 10,),
                        ProfileListItems(path: AppAssets.profile5,
                          textController: websiteController,
                          enabled: enabled.value,),
                        const SizedBox(height: 10,),
                        ProfileListItems(path: AppAssets.profile6,
                          textController: businessIdController,
                          enabled: enabled.value,),
                        const SizedBox(height: 20,),
                        ButtonWidget(onSwipe: ()async{
                          if (enabled.value) {
                            bool success = await homeController.updateCollection(getStringAsync(SharedPrefKey.uid), CollectionsKey.USERS,{
                              UserKey.USERNAME: userNameController.text,
                              UserKey.EMAIL: emailController.text,
                              UserKey.PHONENO: phoneNoController.text,
                              UserKey.ADDRESS: addressController.text,
                              UserKey.WEBSITE: websiteController.text,
                              UserKey.BUSINESSID: businessIdController.text
                            });
                            if (success) {
                              X.showSnackBar(
                                  'Success', 'User data updated successfully!');
                              enabled.value = false;
                            } else {
                              X.showSnackBar('Error', 'Failed to update user data.',);
                            }
                          } else {
                            enabled.value = true;
                          }
                        }, text: !enabled.value ? TempLanguage.txtEdit : 'Save',),
                      ],

                    ),
                  ),
                ),
          ]
          );
        }
    )
    );
  }
}
/**
 *
 *
 * */