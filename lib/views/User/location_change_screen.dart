import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/search_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class LocationChangeScreen extends StatefulWidget {
  const LocationChangeScreen({super.key});

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
          GoogleMap(
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
                    SpacerBoxVertical(height: 30),
                    Row(
                      mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(AppAssets.profileImg, scale: 3,),
                        ),
                        SpacerBoxHorizontal(width: 10),
                        Expanded(
                          
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Skhicken', style: poppinsRegular(fontSize: 14),),
                              Text(TempLanguage.txtLocation, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: Image.asset(AppAssets.notificationImg, scale: 3,)
                        )
                      ],
                    ),
                    SpacerBoxVertical(height: 20),
                    SearchField(),
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
              padding: EdgeInsets.symmetric(horizontal: 1.0), // Padding to ensure the Row is constrained
              child: Row(
                children: [
                  Expanded(
                    child: CommonButton(onSwipe: (){}, text: TempLanguage.btnLblSwipeToSelect),
                  ),
                  SizedBox(width: 10),
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
