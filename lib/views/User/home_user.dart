import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/models/deal_modal.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/User/favourites.dart';
import 'package:swipe_app/widgets/available_list_items.dart';
import 'package:swipe_app/widgets/category_list_items.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  var controller = Get.find<UserController>();
  late StreamController<List<DealModel>> _dealStreamController;
  late List<DealModel> deals;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dealStreamController = StreamController<List<DealModel>>();
    getDeals();
  }

  @override
  void dispose() {
    _dealStreamController.close();
    super.dispose();
  }

  Future<void> getDeals() async {
    deals = await controller.getDeals();
    _dealStreamController.add(deals);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(22.h),child: customAppBar(isSearchField: true),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 12),
                //   child: Text(TempLanguage.txtCategory, style: poppinsMedium(fontSize: 18),),
                // ),
                const SpacerBoxVertical(height: 20),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      SpacerBoxHorizontal(width: 10,),
                      CategoryListItems(path: AppAssets.southFood, text: TempLanguage.txtSouthIndian,),
                      CategoryListItems(path: AppAssets.chineseFood, text: TempLanguage.txtChinese,),
                      CategoryListItems(path: AppAssets.pizzaImg, text: TempLanguage.txtPizza,),
                      CategoryListItems(path: AppAssets.coffeeFood, text: TempLanguage.txtTeaBeverages,),
                      SpacerBoxHorizontal(width: 10,),

                    ],
                  ),
                ),
                const SpacerBoxVertical(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text('Available Deals', style: poppinsMedium(fontSize: 18),),
                ),
                    const SpacerBoxVertical(height: 10),
                StreamBuilder<List<DealModel>>(
                    stream: _dealStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: circularProgressBar());
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        return Center(child: Text('No data available'));
                      }
                      final List<DealModel> deals = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: deals.length,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          final DealModel deal = deals[index];
                          return  GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> FavouritesScreen()));
                              },
                              child: AvailableListItems(dealId: deal.dealId ?? '', dealName: deal.dealName ?? '', restaurantName: deal.companyName ?? '', dealPrice: deal.image ?? '',));
                        },
                      );
                    }
                )
                  ],

            ),
          ],
        ),
      ),
    );
  }
}