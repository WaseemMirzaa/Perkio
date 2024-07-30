import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/views/User/user_profile_view.dart';
import 'package:skhickens_app/widgets/settings_list_items.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  List settingsItems = [
    {
      'icon': AppAssets.evaluationImg,
      'title': TempLanguage.txtManageAccount,
    },
    // {
    //   'icon': AppAssets.managementImg,
    //   'title': TempLanguage.txtSubscription,
    // },
    {
      'icon': AppAssets.networkImg,
      'title': TempLanguage.txtShare,
    },
    {
      'icon': AppAssets.privacyImg,
      'title': TempLanguage.txtTermsConditions,
    },
    {
      'icon': AppAssets.insuranceImg,
      'title': TempLanguage.txtPrivacy,
    },
    {
      'icon': AppAssets.helpImg,
      'title': TempLanguage.txtHelp,
    },
  ];

  var controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AppAssets.profileHeader),
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 5),
              shrinkWrap: true,
              itemCount: settingsItems.length,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index)=> GestureDetector(
                  onTap: (){
                    switch(index){
                      case 0:
                        {
                          getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? Get.to(()=> const UserProfileView()) : Get.toNamed(AppRoutes.profileSettingsBusiness);
                          break;

                        }
                      case 1:{
                        break;
                      }
                      case 2:{
                        Get.toNamed(AppRoutes.termsAndConditions);
                        break;
                      }
                      case 3:{
                        Get.toNamed(AppRoutes.privacyPolicy);
                        break;
                      }
                      case 4:{
                        break;
                      }
                    }
                  },
                  child: SettingsListItems(path: settingsItems[index]['icon'], text: settingsItems[index]['title'],)),
        
            ),
            GestureDetector(
                onTap: (){
                  controller.logout();
                },
                child: const SettingsListItems(path: AppAssets.helpImg, text: 'Logout')),
          ],
        ),
      ),
    );
  }
}