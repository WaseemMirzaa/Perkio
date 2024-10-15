import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/notification_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/deals_service.dart';
import 'package:swipe_app/services/reward_service.dart';
import 'package:swipe_app/views/business/home_business.dart';
import 'package:swipe_app/views/business/home_business_extended.dart';
import 'package:swipe_app/views/business/rewards_business.dart';
import 'package:swipe_app/views/notifications/notifications_view.dart';
import 'package:swipe_app/views/user/deal_detail.dart';
import 'package:swipe_app/views/user/favourites.dart';
import 'package:swipe_app/views/user/home_user.dart';
import 'package:swipe_app/views/user/my_deals.dart';
import 'package:swipe_app/views/user/reward_detail.dart';
import 'package:swipe_app/views/user/settings_view.dart';
import 'package:swipe_app/views/user/rewards_view.dart';
import 'package:swipe_app/widgets/custom_bottom_bar/custom_bottom_bar_items.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView(
      {super.key, required this.isUser, this.isNotificationRoute = false});
  final bool isUser;
  final bool isNotificationRoute;

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  int _selectedIndex = 0;

  RewardService rewardService = Get.put(RewardService());
  DealService dealService = Get.put(DealService());

  final userList = [
    const HomeUser(),
    RewardsView(),
    MyDealsView(),
    FavouritesScreen(),
    SettingsView(
      isUser: true,
    ),
  ];

  final businessList = [
    const HomeBusiness(),
    const RewardsBusiness(),
    const PromotedDealView(),
    SettingsView(
      isUser: false,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Get.put(NotificationController()); // Initialize NotificationController

    if (widget.isNotificationRoute == false) {
      _navigatetoScreen();
    }
  }

  _navigatetoScreen() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) async {
    final String docId = message.data['docId'];
    RewardModel? rewardModel =
        await rewardService.fetchRewardDataFromNotification(docId);
    DealModel? dealModel =
        await dealService.fetchDealDataFromNotification(docId);

    // Check if the user is a regular user or a business user
    if (widget.isUser) {
      // Logic for regular user (when isUser is true)
      if (message.data['notificationType'] == 'newDeal') {
        if (dealModel != null) {
          Get.to(() => DealDetail(deal: dealModel));
        } else {
          print('Failed to fetch deal model for docId: $docId');
        }
      }

      if (message.data['notificationType'] == 'newReward') {
        if (rewardModel != null) {
          Get.to(() => RewardDetail(
                reward: rewardModel,
                userId: rewardService.currentUserUid,
                isNavigationFromNotifications: true,
              ));
        } else {
          print('Failed to fetch reward model for docId: $docId');
        }
      }
    } else {
      // Logic for business user (when isUser is false)
      if (message.data['notificationType'] == 'dealUsed') {
        Get.to(() => const NotificationsView());
      }

      if (message.data['notificationType'] == 'rewardUsed') {
        Get.to(() => const NotificationsView());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        bool shouldClose = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Exit App?',
                style: poppinsBold(fontSize: 15.sp),
              ),
              content: const Text('Do you really want to close the app?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Close App
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors
                        .red, // Customize the color as per your preference
                  ),
                  child: const Text('Close App'),
                ),
              ],
            );
          },
        );
        if (shouldClose) {
          SystemNavigator.pop(); // Close the app
        }
      },
      child: Scaffold(
        body: widget.isUser
            ? userList.elementAt(_selectedIndex)
            : businessList.elementAt(_selectedIndex),
        bottomNavigationBar: widget.isUser
            ? Container(
                height: 7.h,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: Offset(0, -7)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomBottomBarItem(
                        icon: Icons.home,
                        path: AppAssets.navBarIcon1,
                        isSelected: _selectedIndex == 0,
                        onTap: () => _onItemTapped(0),
                      ),
                      CustomBottomBarItem(
                        icon: Icons.star_border,
                        path: AppAssets.navBarIcon2,
                        isSelected: _selectedIndex == 1,
                        onTap: () => _onItemTapped(1),
                      ),
                      CustomBottomBarItem(
                        icon: Icons.assignment,
                        path: AppAssets.navBarIcon3,
                        isSelected: _selectedIndex == 2,
                        onTap: () => _onItemTapped(2),
                      ),
                      CustomBottomBarItem(
                        icon: Icons.favorite_border,
                        path: AppAssets.navBarIcon4,
                        isSelected: _selectedIndex == 3,
                        onTap: () => _onItemTapped(3),
                      ),
                      CustomBottomBarItem(
                        icon: Icons.person_outline,
                        path: AppAssets.navBarIcon5,
                        isSelected: _selectedIndex == 4,
                        onTap: () => _onItemTapped(4),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                height: 7.h,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: Offset(0, -7)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomBottomBarItem(
                        icon: Icons.home,
                        path: AppAssets.navBarIcon1,
                        isSelected: _selectedIndex == 0,
                        onTap: () => _onItemTapped(0),
                      ),
                      CustomBottomBarItem(
                        icon: Icons.star_border,
                        path: AppAssets.navBarIcon2,
                        isSelected: _selectedIndex == 1,
                        onTap: () => _onItemTapped(1),
                      ),
                      CustomBottomBarItem(
                        icon: Icons.assignment,
                        path: AppAssets.navBarIcon3,
                        isSelected: _selectedIndex == 2,
                        onTap: () => _onItemTapped(2),
                      ),
                      // CustomBottomBarItem(
                      //   icon: Icons.favorite_border,
                      //   path: AppAssets.navBarIcon4,
                      //   isSelected: _selectedIndex == 3,
                      //   onTap: () => _onItemTapped(3),
                      // ),
                      CustomBottomBarItem(
                        icon: Icons.person_outline,
                        path: AppAssets.navBarIcon5,
                        isSelected: _selectedIndex == 3,
                        onTap: () => _onItemTapped(3),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
