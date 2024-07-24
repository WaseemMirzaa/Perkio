import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/modals/user_modal.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/profile_list_items.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class ProfileSettingsBusiness extends StatefulWidget {
  const ProfileSettingsBusiness({super.key});

  @override
  State<ProfileSettingsBusiness> createState() => _ProfileSettingsBusinessState();
}

class _ProfileSettingsBusinessState extends State<ProfileSettingsBusiness> {
  
  var controller = Get.find<UserController>();
  late StreamController<UserModel> _userProfileStreamController;
  late UserModel businessProfile;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
    businessProfile = await controller.getUser();
    _userProfileStreamController.add(businessProfile);

    userNameController.text = businessProfile.userName ?? '';
    emailController.text = businessProfile.email ?? '';
    phoneNoController.text = businessProfile.phoneNo ?? '';
    addressController.text = businessProfile.address ?? '';
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
          final businessProfile = snapshot.data!;
          return Stack(
            children: [
              Image.asset(AppAssets.imageHeader),
              BackButtonWidget(),
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
                  Positioned(
                    right: 0,
                    top: 205,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Text(TempLanguage.txtEdit, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                    )),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Column(
                  children: [
                    
                    SpacerBoxVertical(height: 20),
                    Expanded(child: ListView(
                      children: [
                        ProfileListItems(path: AppAssets.profile1, text: businessProfile.userName ?? ''),
                        ProfileListItems(path: AppAssets.profile2, text: businessProfile.phoneNo ?? ''),
                        ProfileListItems(path: AppAssets.profile3, text: businessProfile.email ?? ''),
                        ProfileListItems(path: AppAssets.profile4, text: businessProfile.address ?? 'Not Set'),
                        ProfileListItems(path: AppAssets.profile5, text: TempLanguage.txtWebsite),
                        ProfileListItems(path: AppAssets.profile6, text: TempLanguage.txtDummyBusinessId),
                        GestureDetector(
                          onTap: (){
                            controller.logout();
                          },
                          child: ProfileListItems(path: AppAssets.profile6, text: 'Logout')),
                      ],
                    )),
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