import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/business/home_business.dart';
import 'package:swipe_app/views/business/home_business_extended.dart';
import 'package:swipe_app/views/business/rewards_business.dart';
import 'package:swipe_app/views/user/favourites.dart';
import 'package:swipe_app/views/user/home_user.dart';
import 'package:swipe_app/views/user/my_deals.dart';
import 'package:swipe_app/views/user/settings_view.dart';
import 'package:swipe_app/views/user/rewards_view.dart';
import 'package:swipe_app/widgets/custom_bottom_bar/custom_bottom_bar_items.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({required this.isUser});
  final bool isUser;

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {

  int _selectedIndex = 0;

  final userList = [
    const HomeUser(),
    const RewardsView(),
     MyDealsView(),
    FavouritesScreen(),
    const SettingsView(),
  ];

  final businessList = [
    HomeBusiness(),
    RewardsBusiness(),
    PromotedDealView(),
    const SettingsView(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked : (didPop)async {
        bool shouldClose = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App?',style: poppinsBold(fontSize: 15.sp),),
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
                    foregroundColor: Colors.red, // Customize the color as per your preference
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
        body: widget.isUser ? userList.elementAt(_selectedIndex) : businessList.elementAt(_selectedIndex),
        bottomNavigationBar: widget.isUser ? Container(
          height: 7.h,
          decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: Offset(0, -7)
                ),
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
      
        ) : Container(
          height: 7.h,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: Offset(0, -7)
              ),
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