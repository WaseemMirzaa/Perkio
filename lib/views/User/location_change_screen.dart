import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/search_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class LocationChangeScreen extends StatefulWidget {
  LocationChangeScreen({super.key, this.isChangeLocation = false});
  bool isChangeLocation;

  @override
  State<LocationChangeScreen> createState() => _LocationChangeScreenState();
}

class _LocationChangeScreenState extends State<LocationChangeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          const GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
          ),
          Stack(
            children: [
              CustomShapeContainer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SpacerBoxVertical(height: 30),
                    Row(children: [
                      CircleAvatar(radius: 20.sp,
                        backgroundImage: const AssetImage(AppAssets.profileImg),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(child:  Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [
                        Text( 'Skhicken', style: poppinsRegular(fontSize: 13.sp),),
                        Row(
                          children: [
                            Text('Islamabad', style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                            const SizedBox(width: 10,),
                            // GestureDetector(onTap: (){
                            //   Get.to(()=>LocationChangeScreen(isChangeLocation: true,));
                            // }, child: Text('Change Location',style: poppinsRegular(fontSize: 8,color: AppColors.blueColor),),)
                          ],
                        ),
                      ],),),
                      GestureDetector(
                          onTap: (){
                            Get.toNamed(AppRoutes.notifications);
                          },
                          child: Image.asset(AppAssets.notificationImg, scale: 3,)),
                    ],
                    ),
                    const SpacerBoxVertical(height: 20),
                    const SearchField(),
                  ],
                ),
              ),
            ],
          ),
          Center(child: Image.asset(AppAssets.locationPin, scale: 3,)),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 1.0), // Padding to ensure the Row is constrained
              child: Row(
                children: [
                  Expanded(
                    child: ButtonWidget(onSwipe: (){
                      widget.isChangeLocation ? Get.back() :
                       Get.to(BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false,));
                    }, text: TempLanguage.btnLblSwipeToSelect),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(AppAssets.currentLocationPin, scale: 3,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
