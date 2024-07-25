import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/profile_list_items.dart';
import 'package:skhickens_app/widgets/settings_list_items.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  var controller = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
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
                          SpacerBoxHorizontal(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            
                            Text(TempLanguage.txtSkhickens, style: poppinsRegular(fontSize: 14),),
                            Text(TempLanguage.txtViewProfile, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                          ],),
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              children: [
                
                SpacerBoxVertical(height: 20),
                Expanded(child: ListView(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.profileSettingUser);
                      },
                      child: SettingsListItems(path: AppAssets.evaluationImg, text: TempLanguage.txtManageAccount)),
                    SettingsListItems(path: AppAssets.managementImg, text: TempLanguage.txtSubscription),
                    SettingsListItems(path: AppAssets.networkImg, text: TempLanguage.txtShare),
                    SettingsListItems(path: AppAssets.privacyImg, text: TempLanguage.txtTermsConditions),
                    SettingsListItems(path: AppAssets.insuranceImg, text: TempLanguage.txtPrivacy),
                    SettingsListItems(path: AppAssets.helpImg, text: TempLanguage.txtHelp),
                    GestureDetector(
                      onTap: (){
                        controller.logout();
                      },
                      child: SettingsListItems(path: AppAssets.helpImg, text: 'Logout')),
                  ],
                ))
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}