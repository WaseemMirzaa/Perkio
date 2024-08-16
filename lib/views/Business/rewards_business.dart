import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/modals/deal_modal.dart';
import 'package:swipe_app/modals/reward_modal.dart';
import 'package:swipe_app/routes/app_routes.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/views/Business/add_rewards.dart';
import 'package:swipe_app/widgets/business_rewards_tiles.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/primary_layout_widget/primary_layout.dart';

import '../../core/utils/constants/app_const.dart';
import '../../widgets/custom_appBar/custom_appBar.dart';

class RewardsBusiness extends StatelessWidget {
  RewardsBusiness({super.key});

  final businessController = Get.put(BusinessController(BusinessServices()));

  @override
  Widget build(BuildContext context) {
    return PrimaryLayoutWidget(
        header: SizedBox(height: 16.h,child: customAppBar(),),
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 17.h,),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(TempLanguage.lblMyRewards, style: poppinsMedium(fontSize: 18),),
              ),
              SpacerBoxVertical(height: 1.h),
              StreamBuilder<List<RewardModel>>(
                  stream: businessController.getMyRewardsDeal(getStringAsync(SharedPrefKey.uid)),
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
                          return BusinessRewardsTiles(rewardModel: rewards,);
                        }
                    );
                  }
              ),
              SpacerBoxVertical(height: 10.h),
            ],
          ),
        ),
        footer:  Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ButtonWidget(onSwipe: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddRewards()));
            }, text: TempLanguage.btnLblSwipeToAddRewards),
          ),
        ),);
  }
}