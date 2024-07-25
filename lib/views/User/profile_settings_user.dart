import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/modals/user_modal.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/profile_list_items.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/snackbar_widget.dart';

class ProfileSettingsUser extends StatefulWidget {
  const ProfileSettingsUser({super.key});

  @override
  State<ProfileSettingsUser> createState() => _ProfileSettingsUserState();
}

class _ProfileSettingsUserState extends State<ProfileSettingsUser> {
  var controller = Get.find<UserController>();
  late StreamController<UserModel> _userProfileStreamController;
  late UserModel userProfile;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  RxBool enabled = false.obs;

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
    userProfile = await controller.getUser();
    _userProfileStreamController.add(userProfile);

    userNameController.text = userProfile.userName ?? '';
    emailController.text = userProfile.email ?? '';
    phoneNoController.text = userProfile.phoneNo ?? '';
    addressController.text = userProfile.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: StreamBuilder<UserModel>(
        stream: _userProfileStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }
          final userProfile = snapshot.data!;
          return Stack(
            children: [
              Image.asset(AppAssets.profileHeader),
              Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SpacerBoxVertical(height: 40),
                        Row(
                          children: [
                            Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 3)
                              )
                            ],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.arrow_back),
                              ),
                              
                            
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx((){
                    return Positioned(
                    right: 0,
                    top: 205,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: GestureDetector(
                        onTap: () async {
                          if(enabled.value){
                            
                          bool success = await controller.updateUser({
                            'userName': userNameController.text,
                            'email': emailController.text,
                            'phoneNo': phoneNoController.text,
                            'address': addressController.text,
                          });
                          if (success) {
                            // Update successful
                            snackBar(
                                'Success', 'User data updated successfully!',);
                            // Get.snackbar(
                            //     'Success', 'User data updated successfully!',
                            //     snackPosition: SnackPosition.TOP);
                                enabled.value = false;
                          } else {
                            // Update failed
                            snackBar('Error', 'Failed to update user data.',);
                            // Get.snackbar('Error', 'Failed to update user data.',
                            //     snackPosition: SnackPosition.TOP);
                          
                        }
                          } else enabled.value = true;
                          
                          
                        },
                        child: Text(!enabled.value ? TempLanguage.txtEdit : 'Save', style: poppinsRegular(fontSize: 10, color: AppColors.hintText),)),
                    ));
                  }
                  ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Column(
                  children: [
                    
                    SpacerBoxVertical(height: 20),
                    Expanded(child: Obx((){
                      return ListView(
                      children: [
                        ProfileListItems(path: AppAssets.profile1, textController: userNameController, enabled: enabled.value,),
                        ProfileListItems(path: AppAssets.profile2, textController: phoneNoController, enabled: enabled.value,),
                        ProfileListItems(path: AppAssets.profile3, textController: emailController,),
                        ProfileListItems(path: AppAssets.profile4, textController: addressController, enabled: enabled.value,),
                      ],
                    );
                    })),
                    
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}