import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_common.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/views/user/reward_detail.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:swipe_app/widgets/rewards_list_items.dart';

class RewardsView extends StatefulWidget {
  const RewardsView({super.key});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> {
  final RewardController _controller = Get.put(RewardController());
  final UserController userController = Get.find<UserController>();
  late List<RewardModel> allRewards; // To hold all rewards
  late List<RewardModel> filteredRewards; // To hold filtered rewards
  final TextEditingController searchController = TextEditingController();
  late StreamController<List<RewardModel>> _rewardStreamController;

  // Added this to keep track of the search query
  String searchQuery = '';

  late final String currentUserUid; // `late final` to ensure it's set only once

  @override
  void initState() {
    super.initState();
    _rewardStreamController = StreamController<List<RewardModel>>();
    allRewards = []; // Initialize the list for all rewards
    filteredRewards = []; // Initialize the list for filtered rewards
    getRewards();

    // Initialize the user ID immediately on widget creation
    final user = FirebaseAuth.instance.currentUser;

    // Check if user is logged in and fetch the UID
    if (user != null) {
      currentUserUid = user.uid;
    } else {
      // Handle the case where there is no logged-in user

      return; // Stop further execution if no user is logged in
    }

    // Listen for location changes
    userController.userProfile.listen((user) {
      if (user != null) {
        getRewards(); // Fetch rewards again on location change
      }
    });
  }

  @override
  void dispose() {
    _rewardStreamController.close();
    searchController.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  void searchDeals(String query) {
    searchQuery = query; // Store the search query
    final lowerCaseQuery = query.toLowerCase();

    // Filter rewards based on the search query
    filteredRewards = allRewards.where((reward) {
      final dealName = reward.rewardName?.toLowerCase() ?? '';
      final companyName = reward.companyName?.toLowerCase() ?? '';
      return dealName.contains(lowerCaseQuery) ||
          companyName.contains(lowerCaseQuery);
    }).toList();

    // Update the stream with filtered rewards
    _rewardStreamController.add(filteredRewards);
  }

  void getRewards() {
    _controller.getRewards().listen((newRewards) {
      double userLat = getDoubleAsync(SharedPrefKey.latitude);
      double userLon = getDoubleAsync(SharedPrefKey.longitude);

      // Filter and sort rewards
      allRewards = newRewards.where((reward) {
        double distance = calculateDistance(userLat, userLon,
            reward.latLong!.latitude, reward.latLong!.longitude);
        return distance <= 50.0;
      }).toList();

      allRewards.sort((a, b) {
        double distanceA = calculateDistance(
            userLat, userLon, a.latLong!.latitude, a.latLong!.longitude);
        double distanceB = calculateDistance(
            userLat, userLon, b.latLong!.latitude, b.latLong!.longitude);
        return distanceA.compareTo(distanceB);
      });

      filteredRewards =
          allRewards; // Initialize filtered rewards with all rewards

      // Filter again if there's an active search
      if (searchQuery.isNotEmpty) {
        searchDeals(searchQuery); // Update filtered rewards based on search
      } else {
        _rewardStreamController.add(filteredRewards); // Send initial rewards
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(22.h),
        child: Obx(() {
          if (userController.userProfile.value == null) {
            return customAppBar(
              isSearchField: true,
              onChanged: searchDeals,
              isSearching: _controller.isSearching,
              textController: searchController,
              userName: 'Loading...', // Placeholder text
              userLocation: 'Loading...',
            );
          }

          final user = userController.userProfile.value!;
          final userName = user.userName ?? 'Unknown';
          final userLocation = user.address ?? 'No Address';
          final latLog = user.latLong;

          return customAppBar(
            isReward: true,
            isSearchField: true,
            onChanged: searchDeals,
            isSearching: _controller.isSearching,
            userName: userName,
            latitude: latLog?.latitude ?? 0.0,
            longitude: latLog?.longitude ?? 0.0,
            userLocation: userLocation,
            textController: searchController,
          );
        }),
      ),
      body: StreamBuilder<List<RewardModel>>(
        stream: _rewardStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: circularProgressBar());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading rewards'));
          }
          final List<RewardModel> rewards = snapshot.data ?? [];

          if (rewards.isEmpty) {
            return const Center(child: Text('No rewards found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Rewards',
                    style: poppinsMedium(fontSize: 18),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rewards.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    return GestureDetector(
                      onTap: () {
                        print(
                            'HERE IS THE PASSED ID OF REWARD : ${reward.rewardId}');
                        print(
                            'HERE IS THE PASSED ID OF USER : ${_controller.currentUserId.value}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RewardDetail(
                              reward: reward,
                              userId: currentUserUid,
                            ),
                          ),
                        );
                      },
                      child: RewardsListItems(
                        reward: reward,
                        userId: currentUserUid,
                        isFavFromFavScreen: false,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
