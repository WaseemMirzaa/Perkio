import 'package:firebase_messaging/firebase_messaging.dart';

class FCMManager {
  static String? fcmToken;

  // Method to initialize FCM and request permissions
  static Future<void> initialize() async {
    // Request permission to show notifications
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();

    // Check if permission is granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // Retrieve the FCM token
      fcmToken = await getFCMToken();
      print('FCM Token: $fcmToken');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Method to get FCM token
  static Future<String?> getFCMToken() async {
    try {
      // Get the FCM token
      String? token = await FirebaseMessaging.instance.getToken();
      return token; // Return the token or null
    } catch (e) {
      print('Error retrieving FCM token: $e');
      return null; // Return null in case of an error
    }
  }
}
