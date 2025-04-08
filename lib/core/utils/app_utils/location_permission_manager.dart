import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';


class LocationPermissionManager {

  static Future<bool> checkStatus() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<PermissionStatus> requestLocationPermission(BuildContext context) async {
    // First check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {

      print('⚠️ Location Services: Disabled');

      _showLocationServicesDialog(context);

      return PermissionStatus.denied;

    }

    // Check current permission status
    LocationPermission geoPermission = await Geolocator.checkPermission();

    // If permission is denied, request it
    if (geoPermission == LocationPermission.denied) {
      print('📍 Requesting location permission...');
      geoPermission = await Geolocator.requestPermission();
    }

    // Handle the permission status
    switch (geoPermission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        print('✅ Location Permission: Granted');
        return PermissionStatus.granted;

      case LocationPermission.denied:
        print('❌ Location Permission: Denied');
        _showPermissionDeniedDialog(context);
        return PermissionStatus.denied;

      case LocationPermission.deniedForever:
        print('⛔ Location Permission: Permanently denied');
        _showPermissionPermanentlyDeniedDialog(context);
        return PermissionStatus.permanentlyDenied;

      default:
        print('⚠️ Location Permission: Unknown status');
        return PermissionStatus.denied;
    }
  }

  void _showLocationServicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
            '📍 Please enable Location Services in your device settings to use this feature.'
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              print('🚫 Settings Dialog: User cancelled');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () async {
              print('⚙️ Opening Location Services settings');
              await Geolocator.openLocationSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            '📍 This app needs location access to provide you with accurate services.\n\n'
                'Please tap "Allow" when prompted for location permission.'
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            '📍 Location permission is required but has been permanently denied.\n\n'
                'Please enable location access in your iPhone Settings:\n'
                '1. Open Settings\n'
                '2. Tap Privacy & Security\n'
                '3. Tap Location Services\n'
                '4. Find and tap this app\n'
                '5. Choose "While Using the App" or "Always"'
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              print('🚫 Settings Dialog: User cancelled');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () async {
              print('⚙️ Opening app settings');
              await openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Future<CheckedPermissionStatus> requestLocationPermission(BuildContext context) async {
  //   // Request location permission
  //   final status = await Permission.location.request();
  //
  //   if (status.isGranted) {
  //     // Permission granted successfully
  //     print('✅ Location Permission: Granted successfully');
  //     return CheckedPermissionStatus.granted;
  //   } else if (status.isDenied) {
  //     // User denied the permission but not permanently
  //     print('❌ Location Permission: Denied by user');
  //     // TODO: Consider showing a dialog explaining why the app needs location
  //     return CheckedPermissionStatus.denied;
  //   } else if (status.isPermanentlyDenied) {
  //     // User permanently denied the permission
  //     print('⛔ Location Permission: Permanently denied - needs settings access');
  //     // _showSettingsDialog(context);
  //     return CheckedPermissionStatus.isPermanentlyDenied;
  //
  //   } else {
  //     // Handle other cases like restricted (iOS) or limited
  //     print('⚠️ Location Permission: Other status - ${status.toString()}');
  //     return CheckedPermissionStatus.denied;
  //   }
  // }

  void _showSettingsDialog(BuildContext context) {
    // Create and show a dialog to direct the user to the app settings
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              "Location access is required to use this feature. Please enable it in Settings."),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static bool isDisplayed = false;

  static isLocationPermissionEnabled(BuildContext context) async {


    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
              'Please enable location services in your device settings to use this feature.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
                // isDisplayed = false;
                // onDenied();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                Geolocator.openLocationSettings();
                // Navigator.pop(context);
                // isDisplayed = false;
              },
            ),
          ],
        ),
      );

      return;

    }

    LocationPermission permission = await Geolocator.checkPermission();
    bool isGranted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    return isGranted;
  }

  static Future<void> requestLocationPermissionWithConsentDialog(
      {BuildContext? scaffoldContext,
      required Function onGranted,
      required Function onDenied}) async {

    // Check both location service and permission status

    // if (isDisplayed) {
    //
    //   print('🎈🎈🎈🎈 requestLocationPermissionWithConsentDialog isDisplayed');
    //   return;
    // }
    isDisplayed = true;

    print('🎈🎈🎈🎈 requestLocationPermissionWithConsentDialog isDisplayed == false');



    print('🎈🎈🎈🎈 requestLocationPermissionWithConsentDialog isDisplayed == false');

      await aboutLocationDialog(
        scaffoldContext!,
        () async {
          await requestLocationPermissions(scaffoldContext)
              .then((isGrantedNow) {
            isDisplayed = false;
            if (isGrantedNow) {
              onGranted();
              Get.back();
            } else {
              print("On Denied");
              // Check if permission is permanently denied
              Permission.location.status.then((status) {
                if (status.isPermanentlyDenied) {
                  showDialog(
                    context: scaffoldContext,
                    builder: (context) => const PermissionDeniedDialog(),
                  );
                } else {
                  onDenied();
                }
              });
              Get.back();
            }
          });
        },
      );

  }

  static Future<void> aboutLocationDialog(
          BuildContext scaffoldContext, Function()? onPressed) =>
      showDialog(
        context: scaffoldContext,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              'Location Usage Disclosure',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            content: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Swipe App uses location permissions in the background to provide accurate business and user address information. This allows the app to offer precise location-based services and ensure users and businesses receive timely updates relevant to their location.',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'By continuing, you agree to use of your location in the background',
                    style: TextStyle(
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(child: Text('Next'), onPressed: onPressed)
            ],
          );
        },
      );

  static Future<bool> requestLocationPermissions(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toast("Location services are disabled.");
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // your App should show an explanatory UI now.
        return false;
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const PermissionDeniedDialog(),
      );
      return false;
    }

    return true;
  }
}

class PermissionDeniedDialog extends StatelessWidget {
  const PermissionDeniedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Permission Denied"),
      content: const Text(
          "You have permanently denied the required permission. Please go to the app settings to enable the permission."),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
        ),
        TextButton(
          child: const Text("Open Settings"),
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
