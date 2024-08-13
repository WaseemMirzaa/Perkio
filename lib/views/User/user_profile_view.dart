import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' as NBUtils;
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
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/profile_list_items.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/snackbar_widget.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  var controller = Get.find<UserController>();
  late StreamController<UserModel> _userProfileStreamController;
  late UserModel? userProfile;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  RxBool enabled = false.obs;

  final homeController = Get.put(HomeController(HomeServices()));

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
    userProfile = await controller.getUser(NBUtils.getStringAsync(SharedPrefKey.uid));
    _userProfileStreamController.add(userProfile!);

    userNameController.text = userProfile?.userName ?? '';
    emailController.text = userProfile?.email ?? '';
    phoneNoController.text = userProfile?.phoneNo ?? '';
    addressController.text = userProfile?.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: StreamBuilder<UserModel>(
          stream: _userProfileStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: circularProgressBar());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }
            final userProfile = snapshot.data!;
            return Column(
            children: [
              Stack(children: [
                Image.asset(AppAssets.profileHeader),
                BackButtonWidget(),
                Positioned(
                  right: 3.w,
                  top: 6.h,
                  child: GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle
                        ),child: Icon(Icons.edit,size: 20.sp,)),
                  ),
                ),

              ],),
              Align(
                  alignment: Alignment.centerRight,
                  child: Obx((){
                    return Padding(
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                              onTap: () async {
                                if(enabled.value){

                                  bool success = await homeController.updateCollection(NBUtils.getStringAsync(SharedPrefKey.uid), CollectionsKey.USERS,{
                                    UserKey.USERNAME: userNameController.text,
                                    UserKey.EMAIL: emailController.text,
                                    UserKey.PHONENO: phoneNoController.text,
                                    UserKey.ADDRESS: addressController.text,
                                  });
                                  if (success) {
                                    // Update successful
                                    showSnackBar(
                                      'Success', 'User data updated successfully!',);
                                    // Get.snackbar(
                                    //     'Success', 'User data updated successfully!',
                                    //     snackPosition: SnackPosition.TOP);
                                    enabled.value = false;
                                  } else {
                                    // Update failed
                                    showSnackBar('Error', 'Failed to update user data.',);
                                    // Get.snackbar('Error', 'Failed to update user data.',
                                    //     snackPosition: SnackPosition.TOP);

                                  }
                                } else enabled.value = true;


                              },
                              child: Text(!enabled.value ? TempLanguage.txtEdit : 'Save', style: poppinsRegular(fontSize: 10, color: AppColors.hintText),)),
                        );
                  }
                  ),),
              Expanded(child: Obx(()=> ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),

                  children: [
                    ProfileListItems(path: AppAssets.profile1, textController: userNameController, enabled: enabled.value,),
                    ProfileListItems(path: AppAssets.profile2, textController: phoneNoController, enabled: enabled.value,),
                    ProfileListItems(path: AppAssets.profile3, textController: emailController,),
                    ProfileListItems(path: AppAssets.profile4, textController: addressController, enabled: enabled.value,),

                  ],
                ),
              )),
            ],
          );
        }
      ),
    );
  }
}