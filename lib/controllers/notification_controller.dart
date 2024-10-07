import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController extends GetxController {
  final CollectionReference _notificationsCollection =
      FirebaseFirestore.instance.collection('notification');

  // Observable for notifications
  var notifications = <NotificationModel>[].obs;

  DocumentSnapshot? lastDoc; // Last document for pagination

  // Observable variables to track unread notifications
  var unreadBusinessNotificationCount = 0.obs;
  var unreadUserNotificationCount = 0.obs;

  String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchInitialNotifications(); // Fetch initial notifications
    countUnreadBusinessNotifications(); // Count unread Business notifications
    countUnreadUserNotifications(); // Count unread User notifications
  }

  // Fetch initial notifications
  void fetchInitialNotifications() async {
    try {
      notifications.value = await fetchNotifications();
      if (notifications.isNotEmpty) {
        lastDoc = await _notificationsCollection
            .doc(notifications.last.notificationId)
            .get(); // Store the last document fetched directly
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notifications: $e');
    }
  }

  // Fetch more notifications for pagination
  void fetchMoreNotifications() async {
    if (lastDoc == null) return;

    try {
      final snapshot = await _notificationsCollection
          .orderBy(NotificationKey.TIMESTAMP, descending: true)
          .startAfterDocument(lastDoc!)
          .limit(10)
          .get();
      final newNotifications = snapshot.docs
          .map((doc) => NotificationModel.fromDocumentSnapshot(doc))
          .toList();
      if (newNotifications.isNotEmpty) {
        lastDoc = snapshot.docs.last;
        notifications.addAll(newNotifications);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch more notifications: $e');
    }
  }

  // Fetch notifications from Firestore
  Future<List<NotificationModel>> fetchNotifications(
      {DocumentSnapshot? lastDoc}) async {
    Query query = _notificationsCollection
        .orderBy(NotificationKey.TIMESTAMP, descending: true)
        .limit(10);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();
    List<NotificationModel> notifications = snapshot.docs
        .map((doc) => NotificationModel.fromDocumentSnapshot(doc))
        .toList();

    if (notifications.isNotEmpty) {
      this.lastDoc = snapshot.docs.last;
    }

    return notifications;
  }

  // Listen to real-time notifications
  Stream<List<NotificationModel>> listenToNotifications() {
    return _notificationsCollection
        .orderBy(NotificationKey.TIMESTAMP, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  // Count unread "Business" notifications for the current user
  void countUnreadBusinessNotifications() {
    _notificationsCollection
        .where('receiverId', isEqualTo: currentUserUid)
        .where('isRead', isEqualTo: false)
        .where('notificationType', isEqualTo: 'Business') // Only "Business" notifications
        .snapshots()
        .listen((snapshot) {
      unreadBusinessNotificationCount.value = snapshot.docs.length;
    });
  }

  // Count unread "User" notifications for the current user
  void countUnreadUserNotifications() {
    _notificationsCollection
        .where('receiverId', isEqualTo: currentUserUid)
        .where('isRead', isEqualTo: false)
        .where('notificationType', isEqualTo: 'User') // Only "User" notifications
        .snapshots()
        .listen((snapshot) {
      unreadUserNotificationCount.value = snapshot.docs.length;
    });
  }
}
