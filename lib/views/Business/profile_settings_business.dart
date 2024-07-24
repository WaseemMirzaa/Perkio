import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Stack(
            children: [

              Image.asset(AppAssets.imageHeader),
              BackButtonWidget(),
            ],
          ),
          // GestureDetector(
          //     onTap: (){
          //       Navigator.pop(context);
          //     },
          //     child: BackButtonWidget()),

              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(TempLanguage.txtEdit, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                  )),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: const [
                        ProfileListItems(path: AppAssets.profile1, text: TempLanguage.txtBusinessName),
                        ProfileListItems(path: AppAssets.profile2, text: TempLanguage.txtDummyPassword),
                        ProfileListItems(path: AppAssets.profile3, text: TempLanguage.txtDummyEmail),
                        ProfileListItems(path: AppAssets.profile4, text: 'United State'),
                        ProfileListItems(path: AppAssets.profile5, text: TempLanguage.txtWebsite),
                        ProfileListItems(path: AppAssets.profile6, text: TempLanguage.txtDummyBusinessId),
                      ],
                    
                    
                    
                          ),
                  ),
      ]
    )


    );
  }
}