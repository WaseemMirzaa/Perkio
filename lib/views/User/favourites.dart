import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/controllers/favourites_screen_controller.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/available_list_items.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/favourites_widget.dart';
import 'package:skhickens_app/widgets/rewards_list_items.dart';
import 'package:skhickens_app/widgets/search_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';


class FavouritesScreen extends StatefulWidget {
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
      body: Stack(
        children: [
          Stack(
            children: [
              CustomShapeContainer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SpacerBoxVertical(height: 30),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: AppColors.whiteColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(AppAssets.profileImg, scale: 3,),
                        ),
                        SpacerBoxHorizontal(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(TempLanguage.txtSkhickens, style: poppinsRegular(fontSize: 14),),
                              Text(TempLanguage.txtLocation, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                            ],
                          ),
                        ),
                        Image.asset(AppAssets.notificationImg, scale: 3,)
                      ],
                    ),
                    SpacerBoxVertical(height: 20),
                    SearchField(),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(TempLanguage.txtYourFavorite, style: poppinsMedium(fontSize: 18),),
                ),
                SpacerBoxVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Obx(() => GestureDetector(
                          onTap: () => myController.selectIndex(0),
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              gradient: myController.selectedIndex.value == 0
                                  ? LinearGradient(
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
                      ),
                      SpacerBoxHorizontal(width: 10),
                      Obx(() => GestureDetector(
                          onTap: () => myController.selectIndex(1),
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              gradient: myController.selectedIndex.value == 1
                                  ? LinearGradient(
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
                      ),
                    ],
                  ),
                ),

                Obx((){
                  return Expanded(
                  child: myController.selectedIndex.value == 0 ? StreamBuilder<List<DealModel>>(
                    stream: _favouritesStreamController.stream,
                    builder: (context, snapshot) {
                       if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData) {
                          return Center(child: Text('No data available'));
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
                  ) : ListView(
                    children: [
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                      RewardsListItems(),
                    ],
                  ),
                );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
