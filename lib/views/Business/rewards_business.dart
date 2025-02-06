import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/business/add_rewards.dart';
import 'package:swipe_app/widgets/business_rewards_tiles.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/primary_layout_widget/primary_layout.dart';

import '../../core/utils/constants/app_const.dart';
import '../../widgets/custom_appBar/custom_appBar.dart';

class RewardsBusiness extends StatefulWidget {
  const RewardsBusiness({super.key});

  @override
  State<RewardsBusiness> createState() => _RewardsBusinessState();
}

class _RewardsBusinessState extends State<RewardsBusiness> {
  final businessController = Get.put(BusinessController(BusinessServices()));
  final userController = Get.put(UserController(UserServices()));

  @override
  Widget build(BuildContext context) {
    return PrimaryLayoutWidget(
      // header: SizedBox(height: 16.h,child: customAppBar(),),
      header: SizedBox(
        height: 16.40.h,
        child: PreferredSize(
          preferredSize: Size.fromHeight(12.h),
          child: Obx(() {
            // Use Obx to react to changes in userProfile
            if (userController.businessProfile.value == null) {
              return customAppBar(
                userName: 'Loading...', // Placeholder text
                userLocation: 'Loading...',
                isNotification: false,
                isChangeBusinessLocation: true,
              );
            }

            // Use the data from the observable
            final user = userController.businessProfile.value!;
            final userName = user.userName ?? 'Unknown';
            final userLocation = user.address ?? 'No Address';
            final latLog = user.latLong;
            final image = user.image;

            return customAppBar(
                userName: userName,
                latitude: latLog?.latitude ?? 0.0,
                longitude: latLog?.longitude ?? 0.0,
                userLocation: userLocation,
                isNotification: false,
                isChangeBusinessLocation: true,
                userImage: image);
          }),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  TempLanguage.lblMyRewards,
                  style: poppinsMedium(fontSize: 18),
                ),
              ),
              SpacerBoxVertical(height: 1.h),
              StreamBuilder<List<RewardModel>>(
                  stream: businessController
                      .getMyRewardsDeal(getStringAsync(SharedPrefKey.uid)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: circularProgressBar());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Rewards available'));
                    }
                    final rewardsDeal = snapshot.data!;
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: rewardsDeal.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final rewards = rewardsDeal[index];
                          return BusinessRewardsTiles(
                            rewardModel: rewards,
                          );
                        });
                  }),
              SpacerBoxVertical(height: 10.h),
            ],
          ),
        ),
      ),
      footer: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ButtonWidget(
            fontSize: 11,
              onSwipe: () {
                homeController.setImageNull();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRewards()));
              },
              text: TempLanguage.btnLblSwipeToAddRewards),
        ),
      ),
    );
  }
}
