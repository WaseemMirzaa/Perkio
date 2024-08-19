import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionManager {
  static Future<bool> checkStatus()async{
    return await Geolocator.isLocationServiceEnabled();
  }
  Future<bool> requestLocationPermission(BuildContext context) async {

    final status = await Permission.location.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // Optionally, show a dialog asking for permission again
      return false;
    } else if (status.isPermanentlyDenied) {
      // Show dialog to open app settings
      _showSettingsDialog(context);
      return false;
    } else {
      // Handle other cases (e.g., restricted)
      return false;
    }
  }

  void _showSettingsDialog(BuildContext context) {
    // Create and show a dialog to direct the user to the app settings
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text("Location access is required to use this feature. Please enable it in Settings."),
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


  static Future<void> requestLocationPermissionWithConsentDialog(
      {BuildContext? scaffoldContext,
        required Function onGranted,
        required Function onDenied}) async {
    if (isDisplayed) {
      return;
    }
    isDisplayed = true;
    bool isGranted = await Permission.location.isGranted;
    if (!isGranted) {
      await aboutLocationDialog(scaffoldContext!, () async {
        await requestLocationPermissions(scaffoldContext).then((isGrantedNow) => {
          isDisplayed = false,
          if (isGrantedNow)
            {
              onGranted(),
            }
          else
            {
              print("On Denied"),
              showDialog(context: scaffoldContext, builder: (context)=>PermissionDeniedDialog())
            },
          Get.back()
        });
      },);
    }
  }

  static Future<void> aboutLocationDialog(BuildContext scaffoldContext, Function()? onPressed)=> showDialog(
    context: scaffoldContext,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Location Usage Disclosure',
          style:
          TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),
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
              SizedBox(height: 15,),
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
          ElevatedButton(
              child: Text('Next'),
              onPressed: onPressed
          )
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
      content: const Text("You have permanently denied the required permission. Please go to the app settings to enable the permission."),
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