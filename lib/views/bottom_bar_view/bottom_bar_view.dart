import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/views/Business/home_business.dart';
import 'package:skhickens_app/views/Business/home_business_extended.dart';
import 'package:skhickens_app/views/Business/rewards_business.dart';
import 'package:skhickens_app/views/User/favourites.dart';
import 'package:skhickens_app/views/User/home_user.dart';
import 'package:skhickens_app/views/User/my_deals.dart';
import 'package:skhickens_app/views/User/settings_view.dart';
import 'package:skhickens_app/views/User/rewards_view.dart';
import 'package:skhickens_app/widgets/custom_bottom_bar/custom_bottom_bar_items.dart';

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
    const HomeBusiness(),
    const RewardsBusiness(),
    const HomeBusinessExtended(),
    const SettingsView(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isUser ? userList.elementAt(_selectedIndex) : businessList.elementAt(_selectedIndex),
      bottomNavigationBar: widget.isUser ? Container(
        height: 50,
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
        height: 50,
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
    );
  }
}