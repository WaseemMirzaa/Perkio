import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/deals_controllers.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';

import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/user/favourites.dart';
import 'package:swipe_app/widgets/available_list_items.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(22.h),
        child: customAppBar(isSearchField: true),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //from here
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    TempLanguage.txtFeaturedCategoryDeals,
                    style: poppinsMedium(fontSize: 18),
                  ),
                ),
                const SpacerBoxVertical(height: 20),
                GetX<DealsController>(
                  init: DealsController(),
                  builder: (controller) {
                    if (controller.isLoading.value) {
                      return Center(child: circularProgressBar());
                    }

                    if (controller.hasError.value) {
                      return Center(child: Text('Error fetching promotions'));
                    }

                    if (controller.promotions.isEmpty) {
                      return Center(child: Text('No promotions available'));
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavouritesScreen()));
                      },
                      child: SizedBox(
                        height: 150, // Set the height of the ListView
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SpacerBoxHorizontal(width: 10),
                            ...controller.promotions.map((doc) {
                              final imageUrl = doc[
                                  'image']; // Assuming 'image' is the field for the image URL
                              final name = doc[
                                  'dealName']; // Assuming 'dealName' is the field for the deal name
                              final dealId = doc['dealId'];
                              final companyName = doc['companyName'];
                              final uses = doc['uses'];
                              final location = doc['location'];

                              return SizedBox(
                                width: 350, // Set the width for each item

                                child: AvailableListItems(
                                  image: imageUrl,
                                  dealName: name,
                                  dealId: dealId,
                                  restaurantName: companyName,
                                  uses: uses.toString(),
                                  location: location,
                                ),
                              );
                            }).toList(),
                            SpacerBoxHorizontal(width: 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SpacerBoxVertical(height: 20),

                //to here
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Available Deals',
                    style: poppinsMedium(fontSize: 18),
                  ),
                ),
                const SpacerBoxVertical(height: 10),
                StreamBuilder<List<DealModel>>(
                    stream: _dealStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: circularProgressBar());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
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
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FavouritesScreen()));
                              },
                              child: AvailableListItems(
                                dealId: deal.dealId ?? '',
                                dealName: deal.dealName ?? '',
                                restaurantName: deal.companyName ?? '',
                                uses: deal.uses.toString(),
                                isFeatured: deal.isPromotionStar!,
                                image: deal.image ?? '',
                                location: deal.location ?? '',
                              ));
                        },
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
