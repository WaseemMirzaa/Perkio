import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/user/favourites.dart';
import 'package:swipe_app/widgets/available_list_items.dart';
import 'package:swipe_app/widgets/common/common_widgets.dart';
import 'package:swipe_app/widgets/common_comp.dart';
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
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dealStreamController = StreamController<List<DealModel>>();
    getDeals();

    // Listen to search field changes
    searchController.addListener(() {
      searchDeals(searchController.text);
    });
  }

  @override
  void dispose() {
    _dealStreamController.close();
    searchController.dispose();
    super.dispose();
  }

  Future<void> getDeals() async {
    deals = await controller.getDeals();
    double userLat = getDoubleAsync(SharedPrefKey.latitude);
    double userLon = getDoubleAsync(SharedPrefKey.longitude);

    deals.sort((a, b) {
      double distanceA = calculateDistance(
          userLat, userLon, a.longLat!.latitude, a.longLat!.longitude);
      double distanceB = calculateDistance(
          userLat, userLon, b.longLat!.latitude, b.longLat!.longitude);

      return distanceA.compareTo(distanceB);
    });

    _dealStreamController.add(deals);
  }

  void searchDeals(String query) {
    final lowerCaseQuery = query.toLowerCase();
    final filteredDeals = deals.where((deal) {
      final dealName = deal.dealName?.toLowerCase() ?? '';
      final companyName = deal.companyName?.toLowerCase() ?? '';
      final isMatch = dealName.contains(lowerCaseQuery) ||
          companyName.contains(lowerCaseQuery);
      return isMatch;
    }).toList();

    _dealStreamController.add(filteredDeals);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(22.h),
        child: customAppBar(
          isSearchField: true,
          onChanged: searchDeals,
          isSearching: controller.isSearching,
        ),
      ),
      body: Obx(() {
        bool isSearching = controller.isSearching.value;

        return StreamBuilder<List<DealModel>>(
          stream: _dealStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: circularProgressBar()); // Centered loading indicator
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No deals available'));
            }

            final List<DealModel> deals = snapshot.data!;

            List<DealModel> featuredDeals =
                deals.where((deal) => deal.isPromotionStar == true).toList();
            List<DealModel> availableDeals = deals.toList();

            // Combine featured and available deals
            List<Widget> combinedList = [];

            if (isSearching) {
              combinedList.add(
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Searched Deals',
                    style: poppinsMedium(fontSize: 18),
                  ),
                ),
              );
              combinedList.add(const SizedBox(height: 10));

              combinedList.addAll(deals.where((deal) {
                return deal.dealName!
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()) ||
                    deal.companyName!
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase());
              }).map((deal) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavouritesScreen(),
                      ),
                    );
                  },
                  child: AvailableListItems(
                    dealId: deal.dealId ?? '',
                    dealName: deal.dealName ?? '',
                    restaurantName: deal.companyName ?? '',
                    uses: deal.uses.toString(),
                    isFeatured: deal.isPromotionStar!,
                    image: deal.image ?? '',
                    location: deal.location ?? '',
                  ),
                );
              }).toList());
            } else {
              combinedList.add(
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    TempLanguage.txtFeaturedCategoryDeals,
                    style: poppinsMedium(fontSize: 18),
                  ),
                ),
              );
              combinedList.add(const SizedBox(height: 10));

              combinedList.add(
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredDeals.length,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (BuildContext context, int index) {
                      final DealModel deal = featuredDeals[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavouritesScreen(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 350,
                          child: AvailableListItems(
                            dealId: deal.dealId ?? '',
                            dealName: deal.dealName ?? '',
                            restaurantName: deal.companyName ?? '',
                            uses: deal.uses.toString(),
                            isFeatured: deal.isPromotionStar!,
                            image: deal.image ?? '',
                            location: deal.location ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );

              combinedList.add(const SizedBox(height: 20));

              combinedList.add(
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Available Deals',
                    style: poppinsMedium(fontSize: 18),
                  ),
                ),
              );
              combinedList.add(const SizedBox(height: 10));

              combinedList.addAll(availableDeals.map((deal) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavouritesScreen(),
                      ),
                    );
                  },
                  child: AvailableListItems(
                    dealId: deal.dealId ?? '',
                    dealName: deal.dealName ?? '',
                    restaurantName: deal.companyName ?? '',
                    uses: deal.uses.toString(),
                    isFeatured: deal.isPromotionStar!,
                    image: deal.image ?? '',
                    location: deal.location ?? '',
                  ),
                );
              }).toList());
            }
            return ListView(
              children: combinedList,
            );
          },
        );
      }),
    );
  }
}
