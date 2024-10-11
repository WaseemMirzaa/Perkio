import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/place_picker/permission_utils.dart';

class LocationService extends StatefulWidget {
  final Widget child;

  const LocationService({super.key, required this.child});

  @override
  State<LocationService> createState() => _LocationServiceState();
}

class _LocationServiceState extends State<LocationService> {
  Stream<ServiceStatus>? mergedStream;
  final StreamController<ServiceStatus> mergedStreamController =
      StreamController<ServiceStatus>.broadcast();

  @override
  void initState() {
    super.initState();

    PermissionUtils.checkStatus().then((value) {
      final status = value ? ServiceStatus.enabled : ServiceStatus.disabled;
      mergedStreamController.sink.add(status);
    });

    Geolocator.getServiceStatusStream().listen((locationStatus) {
      if (!mergedStreamController.isClosed) {
        mergedStreamController.sink.add(locationStatus);
      }
    });

    mergedStream = mergedStreamController.stream;
  }

  @override
  void dispose() {
    super.dispose();
    mergedStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ServiceStatus>(
      stream: mergedStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final status = snapshot.data;
          if (status == ServiceStatus.enabled) {
            return widget.child;
          } else {
            return const LocationServiceErrorWidget();
          }
        }
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ); // Loading indicator while waiting for data.
      },
    );
  }
}

class LocationServiceErrorWidget extends StatelessWidget {
  const LocationServiceErrorWidget({super.key});

  Future<void> openLocationSettings(BuildContext context) async {
    // Open the device's location settings
    await Geolocator.openLocationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStartColor,
              AppColors.gradientEndColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Title
                Text(
                  TempLanguage.lblSwipe,
                  style: altoysFont(fontSize: 45, color: AppColors.whiteColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h), // Space between title and text
                // Message
                Text(
                  TempLanguage.txtAllowLocation,
                  style: poppinsRegular(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h), // Space between message and button
                // Button Container
                GestureDetector(
                  onTap: () => openLocationSettings(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 12.sp, horizontal: 24.sp),
                    decoration: BoxDecoration(
                      color: Colors.white, // Button background color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Text(
                      'Open Settings',
                      style: poppinsRegular(
                        color: AppColors.blackColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
