import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/controllers/favourites_screen_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:skhickens_app/widgets/favourites_widget.dart';
import 'package:skhickens_app/widgets/rewards_list_items.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';


class FavouritesScreen extends StatefulWidget {

   FavouritesScreen({super.key, this.isReward = false});
   bool isReward;

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final FavouritesScreenController myController = Get.find<FavouritesScreenController>();

  var controller = Get.find<UserController>();

  late StreamController<List<DealModel>> _favouritesStreamController;

  late List<DealModel> favourites;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _favouritesStreamController = StreamController<List<DealModel>>.broadcast();
    getFavourites();
    Future.microtask((){
      if(widget.isReward){
        myController.selectedIndex(1);
      }else{
        myController.selectedIndex(0);
      }}
    );
  }

  @override
  void dispose() {
    _favouritesStreamController.close();
    super.dispose();
  }

  Future<void> getFavourites() async {
    favourites = await controller.getFavouriteDeals();
    _favouritesStreamController.add(favourites);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(12.h),child: customAppBar(),),
      body: Obx(()=> Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myController.selectedIndex.value == 0 ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(TempLanguage.txtYourFavorite, style: poppinsMedium(fontSize: 18),),
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
                      onTap: () => myController.selectIndex(0),
                      child: Container(
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          gradient: myController.selectedIndex.value == 0
                              ? const LinearGradient(
                                  colors: [Colors.red, Colors.orange],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: myController.selectedIndex.value == 0 ? null : Colors.grey[200],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            TempLanguage.lblMyDeals,
                            style: poppinsRegular(fontSize: 9, color: myController.selectedIndex.value == 0
                                  ? AppColors.whiteColor
                                  : Colors.black,),
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
                                  colors: [Colors.red, Colors.orange],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: myController.selectedIndex.value == 1 ? null : Colors.grey[200],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            TempLanguage.lblMyRewards,
                            style: poppinsRegular(fontSize: 9, color: myController.selectedIndex.value == 1
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
              child: myController.selectedIndex.value == 0 ? StreamBuilder<List<DealModel>>(
                  stream: _favouritesStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No data available'));
                    }
                    final List<DealModel> favourites = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: favourites.length,
                      itemBuilder: (BuildContext context, int index){
                        final DealModel favourite = favourites[index];
                        return GestureDetector(
                            onTap: (){
                              Get.toNamed(AppRoutes.dealDetail);
                            },
                            child: FavouritesWidget(dealName: favourite.dealName ?? '',));
                      },

                    );
                  }
              ) : GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.rewardDetail);
                },
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
