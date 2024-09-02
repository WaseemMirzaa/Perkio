import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/favourites_screen_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
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
  final FavouritesScreenController controller = Get.find<FavouritesScreenController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      if(widget.isReward){
        controller.selectedIndex(1);
      }else{
        controller.selectedIndex(0);
      }}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(12.h),child: customAppBar(),),

      body: Obx(()=> Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.selectedIndex.value == 0 ? Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(TempLanguage.lblMyDeals, style: poppinsMedium(fontSize: 18),),
          ) : Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(TempLanguage.lblMyRewards.capitalizeEachWord(), style: poppinsMedium(fontSize: 18),),
          ),
          const SpacerBoxVertical(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => controller.selectIndex(0),
                  child: Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      gradient: controller.selectedIndex.value == 0
                          ? const LinearGradient(
                        colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      color: controller.selectedIndex.value == 0 ? null : Colors.grey[200],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        TempLanguage.lblMyDeals,
                        style: poppinsRegular(fontSize: 9, color: controller.selectedIndex.value == 0
                            ? AppColors.whiteColor
                            : Colors.black,),
                      ),
                    ),
                  ),

                ),
                const SpacerBoxHorizontal(width: 10),
                GestureDetector(
                  onTap: () => controller.selectIndex(1),
                  child: Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      gradient: controller.selectedIndex.value == 1
                          ? const LinearGradient(
                        colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      color: controller.selectedIndex.value == 1 ? null : Colors.grey[200],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        TempLanguage.lblMyRewards,
                        style: poppinsRegular(fontSize: 9, color: controller.selectedIndex.value == 1
                            ? AppColors.whiteColor
                            : Colors.black,),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            child: controller.selectedIndex.value == 0 ? GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const DealDetail()));
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: const [
                  FavouritesWidget(),
                  FavouritesWidget(),
                  FavouritesWidget(),
                  FavouritesWidget(),
                  FavouritesWidget(),
                ],
              ),
            ) : GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const RewardDetail()));              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: const [
                  RewardsListItems(),
                  RewardsListItems(),
                  RewardsListItems(),
                  RewardsListItems(),
                  RewardsListItems(),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
