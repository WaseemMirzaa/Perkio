import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/notification_model.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:intl/intl.dart'; // Import the intl package
import 'package:swipe_app/controllers/notification_controller.dart'; // Import your controller
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth to get current user

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final NotificationController notificationController =
      Get.put(NotificationController()); // Initialize your controller

  // Get the current user's UID
  String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return SecondaryLayoutWidget(
      header: titleBarComp(TempLanguage.txtNotifications),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 22.h),
            // Use the stream from the notification controller
            StreamBuilder<List<NotificationModel>>(
              stream: notificationController.listenToNotifications(),
              builder: (context, snapshot) {
                // Check if the snapshot has data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: circularProgressBar()); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error: ${snapshot.error}')); // Show error message
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child:
                          Text('No Notifications found')); // No notifications
                }

                // Filter notifications based on receiverId and notificationType
                final filteredNotifications =
                    snapshot.data!.where((notification) {
                  // Check if the current user's UID matches the receiverId
                  return notification.receiverId == currentUserUid &&
                      (notification.notificationType == 'Business' ||
                          notification.notificationType ==
                              'User'); // Add your notification type filter here
                }).toList();

                // If no notifications match the filter
                if (filteredNotifications.isEmpty) {
                  return const Center(
                      child: Text('No relevant notifications.'));
                }

                // If filtered notifications are present, build the list
                return ListView.builder(
                  itemCount: filteredNotifications.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final notification = filteredNotifications[
                        index]; // Access the filtered notification

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align the avatar to the top
                        children: [
                          CircleAvatar(
                            radius: 25.sp,
                            backgroundImage: notification.imageUrl != null
                                ? NetworkImage(notification.imageUrl!)
                                : const AssetImage(AppAssets.profile1),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.notificationTitle!,
                                        style: poppinsBold(fontSize: 11.sp),
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Add space between title and time
                                    Text(
                                      DateFormat('h:mm a').format(notification
                                          .timestamp!
                                          .toDate()), // Format to '11:23 AM'
                                      style: poppinsBold(
                                        fontSize: 9.sp,
                                        color:
                                            AppColors.hintText.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height:
                                        4), // Add space between title and message
                                Text(
                                  notification
                                      .notificationMessage!, // Message body of notification
                                  style: poppinsRegular(fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
