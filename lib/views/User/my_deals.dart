import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/my_deals_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';

import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/views/user/deal_detail.dart';
import 'package:swipe_app/views/user/reward_detail.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:swipe_app/widgets/favourites_widget.dart';
import 'package:swipe_app/widgets/rewards_list_items.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class MyDealsView extends StatefulWidget {
  MyDealsView({super.key, this.isReward = false});
  bool isReward;

  @override
  State<MyDealsView> createState() => _MyDealsViewState();
}

class _MyDealsViewState extends State<MyDealsView> {
  final MyDealScreenController myController =
      Get.put<MyDealScreenController>(MyDealScreenController());

  var controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.isReward) {
        myController.selectIndex(1);
      } else {
        myController.selectIndex(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(12.h),
        child: Obx(() {
          // Use Obx to react to changes in userProfile
          if (controller.userProfile.value == null) {
            return customAppBar(
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
            userName: userName,
            latitude: latLog?.latitude ?? 0.0,
            longitude: latLog?.longitude ?? 0.0,
            userLocation: userLocation,
          );
        }),
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                myController.selectedIndex.value == 0
                    ? TempLanguage.txtDeal
                    : TempLanguage.lblMyRewards.capitalizeEachWord(),
                style: poppinsMedium(fontSize: 18),
              ),
            ),
            const SpacerBoxVertical(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => myController.selectIndex(0),
                    child: Container(
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(
                        gradient: myController.selectedIndex.value == 0
                            ? const LinearGradient(
                                colors: [
                                  AppColors.gradientStartColor,
                                  AppColors.gradientEndColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: myController.selectedIndex.value == 0
                            ? null
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          TempLanguage.lblMyDeals,
                          style: poppinsRegular(
                            fontSize: 9,
                            color: myController.selectedIndex.value == 0
                                ? AppColors.whiteColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SpacerBoxHorizontal(width: 10),
                  GestureDetector(
                    onTap: () => myController.selectIndex(1),
                    child: Container(
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(
                        gradient: myController.selectedIndex.value == 1
                            ? const LinearGradient(
                                colors: [
                                  AppColors.gradientStartColor,
                                  AppColors.gradientEndColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: myController.selectedIndex.value == 1
                            ? null
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          TempLanguage.lblMyRewards,
                          style: poppinsRegular(
                            fontSize: 9,
                            color: myController.selectedIndex.value == 1
                                ? AppColors.whiteColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: myController.selectedIndex.value == 0
                  ? Obx(() {
                      if (myController.favouriteDeals.isEmpty) {
                        return const Center(child: Text('No Deals found'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: myController.favouriteDeals.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DealModel favourite =
                              myController.favouriteDeals[index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DealDetail(
                                              deal: favourite,
                                            )));
                              },
                              child: FavouritesWidget(
                                dealName: favourite.dealName ?? '',
                                restaurantName: favourite.companyName ?? '',
                                dealId: favourite.dealId ?? '',
                                uses: favourite.uses.toString(),
                                location: favourite.location ?? '',
                                image: favourite.image ?? '',
                              ));
                        },
                      );
                    })
                  : Obx(() {
                      if (myController.favouriteRewards.isEmpty) {
                        return const Center(child: Text('No Rewards found'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: myController.favouriteRewards.length,
                        itemBuilder: (BuildContext context, int index) {
                          final reward = myController.favouriteRewards[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RewardDetail(
                                    reward: reward,
                                    userId: myController.currentUserId.value,
                                  ),
                                ),
                              );
                            },
                            child: RewardsListItems(
                              reward: reward,
                              userId: myController.currentUserId.value,
                            ),
                          );
                        },
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }
}
