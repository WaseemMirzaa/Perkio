import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';

import 'package:swipe_app/views/user/deal_detail.dart';
import 'package:swipe_app/widgets/available_list_items.dart';
import 'package:swipe_app/widgets/common/common_widgets.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:nb_utils/nb_utils.dart' as NBUtils;

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

    getUser();
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

  void getDeals() {
    controller.getDeals().listen((newDeals) {
      double userLat = getDoubleAsync(SharedPrefKey.latitude);
      double userLon = getDoubleAsync(SharedPrefKey.longitude);

      // Filter deals within 50km
      deals = newDeals.where((deal) {
        double distance = calculateDistance(
            userLat, userLon, deal.longLat!.latitude, deal.longLat!.longitude);

        // Only include deals within 50km
        return distance <= 50.0;
      }).toList();

      // Sort deals by distance (optional)
      deals.sort((a, b) {
        double distanceA = calculateDistance(
            userLat, userLon, a.longLat!.latitude, a.longLat!.longitude);
        double distanceB = calculateDistance(
            userLat, userLon, b.longLat!.latitude, b.longLat!.longitude);

        return distanceA.compareTo(distanceB);
      });
      // Update the stream with the filtered and sorted deals
      _dealStreamController.add(deals);
    });
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

  //getting the user profile

  LatLng? latLng;

  void getUser() {
    controller
        .gettingUser(NBUtils.getStringAsync(SharedPrefKey.uid))
        .listen((userModel) {
      if (userModel != null) {
        controller.userProfile.value = userModel;
        // Update the user profile
        getDeals();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(22.h),
        child: Obx(() {
          // Use Obx to react to changes in userProfile
          if (controller.userProfile.value == null) {
            return customAppBar(
              isSearchField: true,
              onChanged: searchDeals,
              isSearching: controller.isSearching,
              userName: 'Loading...', // Placeholder text
              userLocation: 'Loading...',
              textController: searchController,
            );
          }

          // Use the data from the observable
          final user = controller.userProfile.value!;
          final userName = user.userName ?? 'Unknown';
          final userLocation = user.address ?? 'No Address';
          final latLog = user.latLong;

          return customAppBar(
            isSearchField: true,
            onChanged: searchDeals,
            isSearching: controller.isSearching,
            userName: userName,
            latitude: latLog?.latitude ?? 0.0,
            longitude: latLog?.longitude ?? 0.0,
            userLocation: userLocation,
            textController: searchController,
          );
        }),
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
            featuredDeals.shuffle();
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
                    print('passed business ID is:${deal.businessId!}');
                    controller.handleBusinessBalanceUpdate(deal.businessId!);
                    controller.incrementDealViews(deal.dealId!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DealDetail(
                          deal: deal,
                        ),
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
                    businessRating: deal.businessRating ?? 0.0,
                    location: deal.location ?? '',
                  ),
                );
              }).toList());
            } else {
              if (featuredDeals.isNotEmpty) {
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
                            controller.incrementDealViews(deal.dealId!);
                            controller
                                .handleBusinessBalanceUpdate(deal.businessId!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DealDetail(
                                  deal: deal,
                                ),
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
                              businessRating: deal.businessRating ?? 0.0,
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
              }

              // Continue with the available deals section
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
                    print('passed business ID is:${deal.businessId!}');
                    controller.handleBusinessBalanceUpdate(deal.businessId!);
                    controller.incrementDealViews(deal.dealId!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DealDetail(
                          deal: deal,
                        ),
                      ),
                    );
                  },
                  child: AvailableListItems(
                    dealId: deal.dealId ?? '',
                    dealName: deal.dealName ?? '',
                    businessRating: deal.businessRating ?? 0.0,
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
