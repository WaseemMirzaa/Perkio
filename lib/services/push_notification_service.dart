import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/deals_service.dart';
import 'package:swipe_app/services/reward_service.dart';
import 'package:swipe_app/views/user/deal_detail.dart';
import 'package:swipe_app/views/user/reward_detail.dart';

class FCMManager {
  static String? fcmToken;

  static Future<String> getFCMToken() async {
    await FirebaseMessaging.instance.requestPermission();
    return await FirebaseMessaging.instance.getToken() ?? '';
  }
}

RewardService rewardService = Get.put(RewardService());
DealService dealService = Get.put(DealService());

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

late AndroidNotificationChannel channel;

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');
DarwinInitializationSettings iosInitializationSettings =
    const DarwinInitializationSettings();

final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: iosInitializationSettings,
);

class PushNotificationServices {
  // static NotificationModel notificationModel = NotificationModel();

  Future<void> init() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    /// Update the iOS foreground notification presentation options to allow
    /// heads up ui.screens.Tabs.notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data.isNotEmpty) {
        String notificationType = message.data['notificationType'];
        String docId = message.data['docId'];

        notificationsPlugin.show(
          1,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: 'appicon',
              channelShowBadge: true,
            ),
            iOS: const DarwinNotificationDetails(
              presentSound: true,
              presentAlert: true,
              presentBadge: true,
            ),
          ),
          payload:
              '$notificationType:$docId', // Pass notificationType and docId in payload
        );
      }
    });

    // handle notification messages when the app is in the background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      String? notificationType = message.data['notificationType'];
      String? docId = message.data['docId'];

      print('🟢🟢🟢Notification Type: $notificationType');
      print('🟢🟢🟢Doc ID: $docId');

      if (notificationType == 'newDeal' && docId!.isNotEmpty) {
        if (docId.isNotEmpty) {
          // Result? resultModel = await fetchPostByDocId(id);
          DealModel? dealModel =
              await dealService.fetchDealDataFromNotification(docId);

          // Get.to(() =>
          //     SingleView(isOtherUserPost: true, resultModel: resultModel));
          Get.to(
            () => DealDetail(
              deal: dealModel,
            ),
          );
        }
      }

      if (notificationType == 'newReward' && docId!.isNotEmpty) {
        if (docId.isNotEmpty) {
          // Result? resultModel = await fetchPostByDocId(id);
          RewardModel? rewardModel =
              await rewardService.fetchRewardDataFromNotification(docId);

          // Get.to(() =>
          //     SingleView(isOtherUserPost: true, resultModel: resultModel));
          Get.to(
            () => RewardDetail(
              reward: rewardModel,
            ),
          );
        }
      }

      // if (notificationType == 'info' && docId != null) {
      //   int? id = int.tryParse(docId);
      //   Result? resultModel = await fetchPostByDocId(id!);

      //   if (resultModel != null) {
      //     Get.to(() => SingleView(
      //           isOtherUserPost: true,
      //           resultModel: resultModel,
      //         ));
      //   }
      // } else {
      //   if (docId != null) {
      //     goToChatScreen(docId);
      //   }
      // }
    });

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      String? payload = response.payload;
      if (payload != null) {
        List<String> payloadData = payload.split(':');
        String notificationType = payloadData[0];
        String docId = payloadData[1];

        if (notificationType == 'newDeal' && docId.isNotEmpty) {
          if (docId.isNotEmpty) {
            // Result? resultModel = await fetchPostByDocId(id);
            DealModel? dealModel =
                await dealService.fetchDealDataFromNotification(docId);

            // Get.to(() =>
            //     SingleView(isOtherUserPost: true, resultModel: resultModel));
            Get.to(
              () => DealDetail(
                deal: dealModel,
              ),
            );
          }
        }

        if (notificationType == 'newReward' && docId.isNotEmpty) {
          if (docId.isNotEmpty) {
            // Result? resultModel = await fetchPostByDocId(id);
            RewardModel? rewardModel =
                await rewardService.fetchRewardDataFromNotification(docId);

            // Get.to(() =>
            //     SingleView(isOtherUserPost: true, resultModel: resultModel));
            Get.to(
              () => RewardDetail(
                reward: rewardModel,
              ),
            );
          }
        }
      }
    });
  }
}

Future<void> sendNotification(
    {required List<dynamic> token,
    required String notificationType,
    required String title,
    required String msg,
    required String docId,
    required bool isGroup,
    required String name,
    required String image,
    required List memberIds,
    required String uid}) async {
  var completeUrl =
      'https://us-central1-skhickens-app.cloudfunctions.net/sendNotification';
  final headers = {'Content-Type': 'application/json'};
  // Loop through each token and send individual notifications
  for (final userToken in token) {
    final body = jsonEncode({
      'token': userToken, // Use each token in the loop
      'title': title,
      'body': msg,
      'notificationType': notificationType,
      'docId': docId,
      'name': name,
      'isGroup': isGroup,
      'image': image,
      'memberIds': memberIds,
    });

    try {
      final response =
          await http.post(Uri.parse(completeUrl), headers: headers, body: body);
      if (response.statusCode == 200) {
        print('🟡🟡🟡Notification sent');
      } else {
        print('🔴🔴🔴Error sending notification: ${response.statusCode}');
        // MessageService.removeDeviceToken(uid, userToken);
      }
    } catch (e) {
      print('🔴🔴🔴Error sending notification: $e');
    }
  }
}
