import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';

class NotificationModel {
  final String? notificationId;
  final String? senderId;
  final String? receiverId;
  final String? notificationTitle;
  final String? notificationMessage;
  final String? notificationType;
  final String? eventId;
  final Timestamp? timestamp;
  final String? imageUrl; // Optional image parameter
  final bool isRead; // Optional isRead parameter

  NotificationModel({
    this.notificationId,
    this.senderId,
    this.receiverId,
    this.notificationTitle,
    this.notificationMessage,
    this.notificationType,
    this.eventId,
    this.timestamp,
    this.imageUrl, // Include image parameter in constructor
    this.isRead = false, // Default isRead to false
  });

  factory NotificationModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return NotificationModel(
      notificationId: snapshot.id,
      senderId: data[NotificationKey.SENDERID] ?? '',
      receiverId: data[NotificationKey.RECEIVERID] ?? '',
      notificationTitle: data[NotificationKey.NOTIFICATIONTITLE] ?? '',
      notificationMessage: data[NotificationKey.NOTIFICATIONMESSAGE] ?? '',
      notificationType: data[NotificationKey.NOTIFICATIONTYPE] ?? '',
      eventId: data[NotificationKey.EVENTID] ?? '',
      timestamp: data[NotificationKey.TIMESTAMP] ?? Timestamp.now(),
      imageUrl: data[NotificationKey.IMAGE], // Retrieve image URL from data
      isRead: data[NotificationKey.ISREAD] ??
          false, // Retrieve isRead status, default to false
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map[NotificationKey.NOTIFICATIONID] ?? '',
      senderId: map[NotificationKey.SENDERID] ?? '',
      receiverId: map[NotificationKey.RECEIVERID] ?? '',
      notificationTitle: map[NotificationKey.NOTIFICATIONTITLE] ?? '',
      notificationMessage: map[NotificationKey.NOTIFICATIONMESSAGE] ?? '',
      notificationType: map[NotificationKey.NOTIFICATIONTYPE] ?? '',
      eventId: map[NotificationKey.EVENTID] ?? '',
      timestamp: map[NotificationKey.TIMESTAMP] ?? Timestamp.now(),
      imageUrl: map[NotificationKey.IMAGE], // Retrieve image URL from map
      isRead: map[NotificationKey.ISREAD] ??
          false, // Retrieve isRead status, default to false
    );
  }

  Map<String, dynamic> toMap() {
    return {
      NotificationKey.NOTIFICATIONID: notificationId ?? '',
      NotificationKey.SENDERID: senderId ?? '',
      NotificationKey.RECEIVERID: receiverId ?? '',
      NotificationKey.NOTIFICATIONTITLE: notificationTitle ?? '',
      NotificationKey.NOTIFICATIONMESSAGE: notificationMessage ?? '',
      NotificationKey.NOTIFICATIONTYPE: notificationType ?? '',
      NotificationKey.EVENTID: eventId ?? '',
      NotificationKey.TIMESTAMP: timestamp ?? Timestamp.now(),
      NotificationKey.IMAGE: imageUrl, // Add image URL to map
      NotificationKey.ISREAD: isRead, // Add isRead status to map
    };
  }
}
