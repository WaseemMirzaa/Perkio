import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/modals/reward_modal.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/services/business_services.dart';
import 'package:skhickens_app/widgets/business_rewards_tiles.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

import '../../core/utils/constants/app_const.dart';
import '../../widgets/custom_appBar/custom_appBar.dart';

class RewardsBusiness extends StatefulWidget {
  const RewardsBusiness({super.key});

  @override
  State<RewardsBusiness> createState() => _RewardsBusinessState();
}

class _RewardsBusinessState extends State<RewardsBusiness> {
  final businessController = Get.put(BusinessController(BusinessServices()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(12.h),child: customAppBar(),),
      body: Column(
        // alignment: Alignment.bottomCenter,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(TempLanguage.lblMyRewards, style: poppinsMedium(fontSize: 18),),
                  ),
                  SpacerBoxVertical(height: 1.h),
                  StreamBuilder<List<RewardModel>>(
                      stream: businessController.getMyRewardsDeal(getStringAsync(SharedPrefKey.uid)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No Rewards available'));
                        }
                        final rewardsDeal = snapshot.data!;
                        return ListView.builder(
                            itemCount: rewardsDeal.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final rewards = rewardsDeal[index];
                              return BusinessRewardsTiles(rewardModel: rewards,);
                            }
                      );
                    }
                  ),
                  SpacerBoxVertical(height: 8.h),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ButtonWidget(onSwipe: (){
                Get.toNamed(AppRoutes.addReward);
              }, text: TempLanguage.btnLblSwipeToAddRewards),
            ),
          ),
        ],
      ),

    );
  }
}