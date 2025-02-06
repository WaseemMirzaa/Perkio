import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';
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

  String? currentUserUid;

  @override
  void onInit() {
    super.onInit();

    // Fetch the current user's UID on init
    _getCurrentUserUid();
  }

  // Method to get current user UID
  void _getCurrentUserUid() async {
    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // If a user is signed in, set the currentUserUid and log it
        currentUserUid = user.uid;
        log("💥💥💥💥💥💥💥 FROM NOTIFCATION CONTROLLER------------Current User ID: $currentUserUid");

        // After setting UID, fetch notifications
        fetchInitialNotifications();
        countUnreadBusinessNotifications();
        countUnreadUserNotifications();
      } else {
        // If no user is signed in, log this information
        log("💥💥💥💥💥💥💥 FROM NOTIFCATION CONTROLLER------------No user is currently signed in.");
      }
    });
  }

  // Fetch initial notifications
  void fetchInitialNotifications() async {
    if (currentUserUid == null) {
      log("User UID is not available, skipping notification fetch.");
      return;
    }

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
    if (lastDoc == null || currentUserUid == null) return;

    try {
      final snapshot = await _notificationsCollection
          .orderBy(NotificationKey.TIMESTAMP, descending: true)
          .startAfterDocument(lastDoc!)
          .limit(10)
          .where('receiverId', isEqualTo: currentUserUid) // Only fetch for current user
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
    if (currentUserUid == null) {
      log("User UID is not available, skipping notification fetch.");
      return [];
    }

    Query query = _notificationsCollection
        .where('receiverId', isEqualTo: currentUserUid) // Only fetch for the current user
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
    if (currentUserUid == null) {
      log("User UID is not available, skipping real-time listener.");
      return const Stream.empty();
    }

    return _notificationsCollection
        .where('receiverId', isEqualTo: currentUserUid) // Only listen for current user's notifications
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
    if (currentUserUid == null) {
      log("User UID is not available, skipping unread count for business notifications.");
      return;
    }

    _notificationsCollection
        .where('receiverId', isEqualTo: currentUserUid) // Only count for current user
        .where('isRead', isEqualTo: false)
        .where('notificationType', isEqualTo: 'Business') // Only "Business" notifications
        .snapshots()
        .listen((snapshot) {
      unreadBusinessNotificationCount.value = snapshot.docs.length;
    });
  }

  // Count unread "User" notifications for the current user
  void countUnreadUserNotifications() {
    if (currentUserUid == null) {
      log("User UID is not available, skipping unread count for user notifications.");
      return;
    }

    _notificationsCollection
        .where('receiverId', isEqualTo: currentUserUid) // Only count for current user
        .where('isRead', isEqualTo: false)
        .where('notificationType', isEqualTo: 'User') // Only "User" notifications
        .snapshots()
        .listen((snapshot) {
      unreadUserNotificationCount.value = snapshot.docs.length;
    });
  }

  // Method to mark a notification as read
  Future<void> markNotificationAsRead() async {
    if (currentUserUid == null) {
      log("User UID is not available, skipping marking notifications as read.");
      return;
    }

    try {
      // Fetch all unread notifications for the current user
      QuerySnapshot snapshot = await _notificationsCollection
          .where('receiverId', isEqualTo: currentUserUid) // Only for current user
          .where('isRead', isEqualTo: false) // Only unread notifications
          .get();

      // Create a batch to perform updates atomically
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add each notification update to the batch
      for (var doc in snapshot.docs) {
        batch.update(_notificationsCollection.doc(doc.id), {'isRead': true});
      }

      // Commit the batch (this executes all the updates in one go)
      await batch.commit();
    } catch (e) {
      log('Error marking notifications as read: $e');
    }
  }
}
