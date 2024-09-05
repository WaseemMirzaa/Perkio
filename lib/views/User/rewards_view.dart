import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/user/reward_detail.dart';
import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:swipe_app/widgets/rewards_list_items.dart';

class RewardsView extends StatelessWidget {
  final RewardController _controller = Get.put(RewardController());

  RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(12.h),
        child: customAppBar(),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.rewards.isEmpty) {
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
                itemCount: _controller.rewards.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  final reward = _controller.rewards[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RewardDetail(
                            reward: reward,
                          ),
                        ),
                      );
                    },
                    child: RewardsListItems(
                      reward: reward,
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
