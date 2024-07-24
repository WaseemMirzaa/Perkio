import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/profile_list_items.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Image.asset(AppAssets.profileHeader),
              BackButtonWidget(),
              Positioned(
                right: 0,
                top: 205,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(TempLanguage.txtEdit, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                )),
          Column(
            children: [
              SpacerBoxVertical(height: 22.h),
              Expanded(child: ListView(
                children: const [
                  ProfileListItems(path: AppAssets.profile1, text: 'Skhicken'),
                  ProfileListItems(path: AppAssets.profile2, text: TempLanguage.txtDummyPassword),
                  ProfileListItems(path: AppAssets.profile3, text: TempLanguage.txtDummyEmail),
                  ProfileListItems(path: AppAssets.profile4, text: 'United State'),
                ],
              ))

            ],
          ),
        ],
      ),
    );
  }
}