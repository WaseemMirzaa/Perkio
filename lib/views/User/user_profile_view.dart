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
      body: Column(
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
            Positioned(
                right: 0,
                top: 205,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(TempLanguage.txtEdit, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                )),
          ],),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(TempLanguage.txtEdit, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
              )),
          Expanded(child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),

            children: const [
              ProfileListItems(path: AppAssets.profile1, text: 'Skhicken'),
              ProfileListItems(path: AppAssets.profile2, text: TempLanguage.txtDummyPassword),
              ProfileListItems(path: AppAssets.profile3, text: TempLanguage.txtDummyEmail),
              ProfileListItems(path: AppAssets.profile4, text: 'United State'),
            ],
          )),
        ],
      ),
    );
  }
}