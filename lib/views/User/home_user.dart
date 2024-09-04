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
    if (query.isEmpty) {
      _dealStreamController.add(deals);
    } else {
      List<DealModel> filteredDeals = deals.where((deal) {
        return deal.dealName!.toLowerCase().contains(query.toLowerCase()) ||
            deal.companyName!.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _dealStreamController.add(filteredDeals);
    }
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
        ),
      ),
      body: Center(
        // Center the entire StreamBuilder content
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content horizontally
            children: [
              StreamBuilder<List<DealModel>>(
                stream: _dealStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularProgressBar(); // This will be centered on the screen
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No deals available'));
                  }

                  final List<DealModel> deals = snapshot.data!;
                  // Filtering deals where isPromotionStar is true
                  final List<DealModel> featuredDeals = deals
                      .where((deal) => deal.isPromotionStar == true)
                      .toList();
                  // Deals that are not featured
                  final List<DealModel> availableDeals = deals.toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Category Deals
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          TempLanguage.txtFeaturedCategoryDeals,
                          style: poppinsMedium(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Horizontal ListView for Featured Deals
                      SizedBox(
                        height:
                            150, // Fixed height for horizontal scrolling deals
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredDeals.length,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                width: 350, // Width for each horizontal item
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

                      const SpacerBoxVertical(height: 20),

                      // Available Deals
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          'Available Deals',
                          style: poppinsMedium(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Vertical ListView for Available Deals
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: availableDeals.length,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (BuildContext context, int index) {
                          final DealModel deal = availableDeals[index];
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
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
