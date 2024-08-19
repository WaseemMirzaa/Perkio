import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/place_picker/permission_utils.dart';

class LocationService extends StatefulWidget {
  final Widget child;

  LocationService({super.key, required this.child});

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
      if(!mergedStreamController.isClosed) {
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
  const LocationServiceErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                AppAssets.currentLocationPin,
                // scale: 4,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 2.h,),
              Text('Please enable GPS on your phone to use the app',style: poppinsBold(fontSize: 12.sp),textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}