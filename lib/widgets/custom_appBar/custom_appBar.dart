import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/views/User/location_change_screen.dart';
import 'package:skhickens_app/widgets/search_field.dart';
import '../../core/utils/constants/app_assets.dart';

Widget customAppBar({String? userName,
  String? userImage,
  String? userLocation,
  bool isLocation = true,
  bool isSearchField = false,

  Color appBarBackColor = AppColors.appBarBackColor,
  Widget? widget,})=>  Stack(
  alignment: Alignment.center,
    children: [
      Image.asset(AppAssets.header,width: 100.w,height: 100.h,fit: BoxFit.fill,),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              CircleAvatar(radius: 20.sp,
                backgroundImage: !getStringAsync(SharedPrefKey.photo).isEmptyOrNull ? NetworkImage(getStringAsync(SharedPrefKey.photo)) : AssetImage(userImage ??AppAssets.profileImg),
              ),
              const SizedBox(width: 10,),
              Expanded(child:  Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [
                Text(userName ?? getStringAsync(SharedPrefKey.userName), style: poppinsRegular(fontSize: 13.sp),),
                isLocation ? Row(
                  children: [
                    Text(userLocation ?? 'Islamabad', style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                    const SizedBox(width: 10,),
                    GestureDetector(onTap: (){
                      Get.to(()=>LocationChangeScreen(isChangeLocation: true,));
                    }, child: Text('Change Location',style: poppinsRegular(fontSize: 8,color: AppColors.blueColor),),)
                  ],
                ) : widget!,
              ],),),
              GestureDetector(
                  onTap: (){
                    Get.toNamed(AppRoutes.notifications);
                  },
                  child: Image.asset(AppAssets.notificationImg, scale: 3,)),
            ],
            ),
            isSearchField ?
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: SearchField(),
            ) : const SizedBox.shrink(),
          ],
        ),
      ),
    ],
  );

