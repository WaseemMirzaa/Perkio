import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';

class NotificationModel{
  final String? notificationId;
  final String? senderId;
  final String? receiverId;
  final String? notificationTitle;
  final String? notificationMessage;
  final String? notificationType;
  final String? eventId;
  final Timestamp? timestamp;

  NotificationModel({this.notificationId, this.senderId, this.receiverId, this.notificationTitle, this.notificationMessage, this.notificationType, this.eventId, this.timestamp});

  factory NotificationModel.fromDocumentSnapshot(DocumentSnapshot snapshot){
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
    );
  }
  factory NotificationModel.fromMap(Map<String, dynamic> map){
    return NotificationModel(
      notificationId: map[NotificationKey.NOTIFICATIONID] ?? '',
      senderId: map[NotificationKey.SENDERID] ?? '',
      receiverId: map[NotificationKey.RECEIVERID] ?? '',
      notificationTitle: map[NotificationKey.NOTIFICATIONTITLE] ?? '',
      notificationMessage: map[NotificationKey.NOTIFICATIONMESSAGE] ?? '',
      notificationType: map[NotificationKey.NOTIFICATIONTYPE] ?? '',
      eventId: map[NotificationKey.EVENTID] ?? '',
      timestamp: map[NotificationKey.TIMESTAMP] ?? Timestamp.now(),
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
    };
  }

}