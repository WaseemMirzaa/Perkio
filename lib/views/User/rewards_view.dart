import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/views/user/reward_detail.dart';
import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:swipe_app/widgets/rewards_list_items.dart';

class RewardsView extends StatelessWidget {
  final RewardController _controller = Get.put(RewardController());
  var controller = Get.find<UserController>();
  final TextEditingController searchController = TextEditingController();

  RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(22.h),
        child: Obx(() {
          // Use Obx to react to changes in userProfile
          if (controller.userProfile.value == null) {
            return customAppBar(
              isSearchField: true,
              onChanged: (value) {
                _controller.isSearching.value = value.isNotEmpty;
                _controller.searchRewards(
                    value); // Filter rewards based on the search input
              },
              isSearching: _controller.isSearching,

              userName: 'Loading...', // Placeholder text
              userLocation: 'Loading...',
            );
          }

          // Use the data from the observable
          final user = controller.userProfile.value!;
          final userName = user.userName ?? 'Unknown';
          final userLocation = user.address ?? 'No Address';
          final latLog = user.latLong;

          return customAppBar(
            isSearchField: true,
            onChanged: (value) {
              _controller.isSearching.value = value.isNotEmpty;
              _controller.searchRewards(
                  value); // Filter rewards based on the search input
            },
            isSearching: _controller.isSearching,
            userName: userName,
            latitude: latLog?.latitude ?? 0.0,
            longitude: latLog?.longitude ?? 0.0,
            userLocation: userLocation,
          );
        }),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        List<RewardModel> rewards = _controller.isSearching.value
            ? _controller.searchedRewards
            : _controller.rewards;

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RewardDetail(
                            reward: reward,
                            userId: _controller.currentUserId.value,
                          ),
                        ),
                      );
                    },
                    child: RewardsListItems(
                      reward: reward,
                      userId: _controller.currentUserId.value,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
