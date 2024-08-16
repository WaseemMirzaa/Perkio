import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/views/place_picker/permission_utils.dart';

class LocationService extends StatefulWidget {
  final Widget child;

  LocationService({super.key, required this.child});

  @override
  State<LocationService> createState() => _LocationServiceState();
}

class _LocationServiceState extends State<LocationService> {
  // final Stream<ServiceStatus> locationStream = Geolocator.getServiceStatusStream();
  // final StreamController<ServiceStatus> customStreamController = StreamController<ServiceStatus>.broadcast();
  //
  // Stream<ServiceStatus>? mergedStream;
  // final StreamController<ServiceStatus> mergedStreamController = StreamController<ServiceStatus>.broadcast();
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   PermissionUtils.checkStatus().then((value) {
  //     if (value) {
  //       customStreamController.sink.add(ServiceStatus.enabled);
  //     } else {
  //       customStreamController.sink.add(ServiceStatus.disabled);
  //     }
  //   });
  //
  //   locationStream.listen(mergedStreamController.sink.add);
  //   customStreamController.stream.listen(mergedStreamController.sink.add);
  //
  //   mergedStream = mergedStreamController.stream;
  // }
  //
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   customStreamController.close();
  //   mergedStreamController.close();
  // }

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
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
                AppAssets.foodImg,
                // scale: 4,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
             Text('Please enable GPS on your phone to use the app'),
            ],
          ),
        ),
      ),
    );
  }
}