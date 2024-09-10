import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/congratulation_dialog.dart';
import 'package:swipe_app/widgets/detail_tile.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class RewardRedeemDetail extends StatefulWidget {
  final RewardModel? rewardModel;
  final String? userId;
  const RewardRedeemDetail({super.key, this.rewardModel, this.userId});

  @override
  State<RewardRedeemDetail> createState() => _RewardRedeemDetailState();
}

class _RewardRedeemDetailState extends State<RewardRedeemDetail> {
  @override
  Widget build(BuildContext context) {
    final rewardModel = widget.rewardModel;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerBoxVertical(height: 20),
              DetailTile(
                businessId: rewardModel?.businessId,
              ),
              const SpacerBoxVertical(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TempLanguage.txtRewardInfo,
                      style: poppinsMedium(fontSize: 13.sp),
                    ),
                    const SpacerBoxVertical(height: 10),
                    Text(
                      rewardModel?.rewardName ??
                          TempLanguage.txtLoremIpsumShort,
                      style: poppinsRegular(
                          fontSize: 10.sp, color: AppColors.hintText),
                    ),
                  ],
                ),
              ),
              const SpacerBoxVertical(height: 20),
              Center(
                child: Text(
                  TempLanguage.txtPoints,
                  style: poppinsBold(
                      fontSize: 13.sp, color: AppColors.secondaryText),
                ),
              ),
              const SpacerBoxVertical(height: 10),
              Center(
                child: Text(
                  '${rewardModel?.pointsEarned?[widget.userId] ?? 0}/${rewardModel?.pointsToRedeem ?? 1000}',
                  style: poppinsBold(
                      fontSize: 13.sp, color: AppColors.secondaryText),
                ),
              ),
              const SpacerBoxVertical(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  height: 45,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        width:
                            (rewardModel?.pointsEarned?[widget.userId] ?? 0) /
                                ((rewardModel?.pointsToRedeem ?? 1) > 0
                                    ? rewardModel!.pointsToRedeem!
                                    : 1) *
                                MediaQuery.of(context)
                                    .size
                                    .width, // Adjust width based on progress

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gradientStartColor,
                              AppColors.gradientEndColor
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SpacerBoxVertical(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ButtonWidget(
                  onSwipe: () {
                    showCongratulationDialog(onDone: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationService(
                            child: BottomBarView(
                              isUser: getStringAsync(SharedPrefKey.role) ==
                                  SharedPrefKey.user,
                            ),
                          ),
                        ),
                        (route) => false,
                      );
                    });
                  },
                  text: TempLanguage.btnLblSwipeToRedeem,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
