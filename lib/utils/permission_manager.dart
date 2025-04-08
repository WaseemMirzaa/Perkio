import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class PermissionManager {
  static Future<bool> checkAndRequestCameraPermission(BuildContext context) async {
    // Check current permission status
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await _showPermissionSettingsDialog(
        context,
        'Camera Permission Required',
        'Camera access is required to scan receipts and upload images. '
            'Please enable it in your device settings.',
      );
    }

    // Request permission
    final result = await Permission.camera.request();

    switch (result) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.permanentlyDenied:
        return await _showPermissionSettingsDialog(
          context,
          'Camera Permission Required',
          'Camera access is required to scan receipts and upload images. '
              'Please enable it in your device settings.',
        );
      case PermissionStatus.denied:
        if (Platform.isAndroid) {
          // On Android, show a dialog explaining why we need the permission
          return await _showExplanationDialog(context);
        }
        return false;
      default:
        return false;
    }
  }

  static Future<bool> _showExplanationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera Permission'),
          content: const Text(
              'We need camera access to scan receipts and upload images for business verification. '
                  'Would you like to grant camera permission?'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No, Thanks'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Grant Permission'),
              onPressed: () async {
                Navigator.of(context).pop(true);
                final result = await Permission.camera.request();
                // return result.isGranted;
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  static Future<bool> _showPermissionSettingsDialog(
      BuildContext context,
      String title,
      String message,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}