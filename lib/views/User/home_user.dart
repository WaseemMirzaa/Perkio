import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/notification_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/user/deal_detail.dart';
import 'package:swipe_app/widgets/available_list_items.dart';
import 'package:swipe_app/widgets/common/common_widgets.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class HomeUser extends StatefulWidget {
  final bool isGuestLogin;
  const HomeUser({super.key, this.isGuestLogin = false});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  final controller = Get.put(UserController(UserServices()));
// final controller = Get.lazyPut(UserController(UserServices()));
  late StreamController<List<DealModel>> _dealStreamController;
  late List<DealModel> deals;
  List<DealModel> featuredDeals = [];
  List<DealModel> availableDeals = [];
  TextEditingController searchController = TextEditingController();

  // Add a flag to track if featured deals have been shuffled
  bool _hasShuffledFeaturedDeals = false;

  // Track if the widget is disposed to avoid issues with stream handling
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _dealStreamController = StreamController<
        List<
            DealModel>>.broadcast(); // Use broadcast if multiple listeners are expected
    getDeals();
    widget.isGuestLogin ? null : getUser();
    Get.find<NotificationController>();

    // Listen to search field changes
    searchController.addListener(() {
      searchDeals(searchController.text);
    });
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark the widget as disposed
    if (!_dealStreamController.isClosed) {
      _dealStreamController.close(); // Close the stream safely
    }
    searchController.dispose();
    super.dispose();
  }

  void getDeals() {
    controller.getDeals().listen((newDeals) {
      // Check if the widget is still mounted before processing the data
      if (_isDisposed) return;

      double userLat = getDoubleAsync(SharedPrefKey.latitude);
      double userLon = getDoubleAsync(SharedPrefKey.longitude);

      // Filter deals within 50km
      deals = newDeals.where((deal) {
        double distance = calculateDistance(
            userLat, userLon, deal.longLat!.latitude, deal.longLat!.longitude);
        return distance <= 50.0; // Only include deals within 50km
      }).toList();

      // Sort deals by distance
      deals.sort((a, b) {
        double distanceA = calculateDistance(
            userLat, userLon, a.longLat!.latitude, a.longLat!.longitude);
        double distanceB = calculateDistance(
            userLat, userLon, b.longLat!.latitude, b.longLat!.longitude);
        return distanceA.compareTo(distanceB);
      });

      // Update featured deals
      featuredDeals =
          deals.where((deal) => deal.isPromotionStar ?? false).toList();

      // Shuffle featured deals only if not shuffled yet
      if (!_hasShuffledFeaturedDeals) {
        featuredDeals.shuffle(Random());
        _hasShuffledFeaturedDeals = true; // Mark as shuffled
      }

      availableDeals = deals;

      // Check if the stream controller is closed or if the widget is disposed
      if (!_dealStreamController.isClosed && !_isDisposed) {
        _dealStreamController.add(deals);
      }
    });
  }

  void searchDeals(String query) {
    final lowerCaseQuery = query.toLowerCase();

    // Check if the widget is still mounted before proceeding
    if (_isDisposed) return;

    final filteredDeals = deals.where((deal) {
      final dealName = deal.dealName?.toLowerCase() ?? '';
      final companyName = deal.companyName?.toLowerCase() ?? '';
      return dealName.contains(lowerCaseQuery) ||
          companyName.contains(lowerCaseQuery);
    }).toList();

    // Add the filtered deals to the stream, ensuring it's still open
    if (!_dealStreamController.isClosed && !_isDisposed) {
      _dealStreamController.add(filteredDeals);
    }
  }

  LatLng? latLng;

  void getUser() {
    String? currentuid = FirebaseAuth.instance.currentUser?.uid;
    controller.gettingUser(currentuid!).listen((userModel) {
      if (_isDisposed) return;

      if (userModel != null) {
        controller.userProfile.value = userModel;
        // Update the user profile and get deals again after loading user
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
              isGuestLogin: true,
              context: context,

              isSearching: controller.isSearching,
              userName: widget.isGuestLogin
                  ? 'John'
                  : 'Loading...', // Placeholder text
              userLocation: widget.isGuestLogin
                  ? getStringAsync(SharedPrefKey.userAddress)
                  : 'Loading...',
              textController: searchController,
            );
          }

          // Use the data from the observable
          final user = controller.userProfile.value!;
          final userName = user.userName ?? 'Unknown';
          final userLocation = user.address ?? 'No Address';
          final latLog = user.latLong;
          final image = user.image ?? 'Unknown';

          return customAppBar(
            isSearchField: true,
            onChanged: searchDeals,
            isSearching: controller.isSearching,
            userName: userName,
            context: context,
            latitude: latLog?.latitude ?? 0.0,
            longitude: latLog?.longitude ?? 0.0,
            userLocation: userLocation,
            textController: searchController,
            userImage: image,
          );
        }),
      ),
      body: Obx(() {
        bool isSearching = controller.isSearching.value;
        return StreamBuilder<List<DealModel>>(
          stream: _dealStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: circularProgressBar());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No deals available'));
            }

            final List<DealModel> deals = snapshot.data!;

            // Use the state variable for featured deals
            List<DealModel> featuredDeals =
                deals.where((deal) => deal.isPromotionStar == true).toList();

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
                    controller.handleBusinessBalanceUpdate(
                        deal.businessId!, deal.dealId!);
                    controller.incrementDealViews(deal.dealId!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DealDetail(
                          deal: deal,
                          isGuestLogin: widget.isGuestLogin,
                        ),
                      ),
                    );
                  },
                  child: AvailableListItems(
                    dealId: deal.dealId ?? '',
                    dealName: deal.dealName ?? '',
                    isGuestLogin: widget.isGuestLogin,
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
                    height: 20.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredDeals.length,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (BuildContext context, int index) {
                        final DealModel deal = featuredDeals[index];
                        return GestureDetector(
                          onTap: () {
                            controller.incrementDealViews(deal.dealId!);
                            controller.handleBusinessBalanceUpdate(
                                deal.businessId!, deal.dealId!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DealDetail(
                                  deal: deal,
                                  isGuestLogin: widget.isGuestLogin,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 95.w,
                            child: AvailableListItems(
                              dealId: deal.dealId ?? '',
                              dealName: deal.dealName ?? '',
                              restaurantName: deal.companyName ?? '',
                              isGuestLogin: widget.isGuestLogin,
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

              // Filter deals to exclude featured ones

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

              // This will be used to display the available deals section
              //-------------comment this line you want to show featured + simple deals----------
              List<DealModel> availableDeals =
                  deals.where((deal) => deal.isPromotionStar != true).toList();
              //-------------comment this line you want to show featured + simple deals----------

              combinedList.addAll(availableDeals.map((deal) {
                return GestureDetector(
                  onTap: () {
                    controller.incrementDealViews(deal.dealId!);
                    controller.handleBusinessBalanceUpdate(
                        deal.businessId!, deal.dealId!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DealDetail(
                          deal: deal,
                          isGuestLogin: widget.isGuestLogin,
                        ),
                      ),
                    );
                  },
                  child: AvailableListItems(
                    dealId: deal.dealId ?? '',
                    dealName: deal.dealName ?? '',
                    restaurantName: deal.companyName ?? '',
                    uses: deal.uses.toString(),
                    isGuestLogin: widget.isGuestLogin,
                    isFeatured: deal.isPromotionStar!,
                    image: deal.image ?? '',
                    businessRating: deal.businessRating ?? 0.0,
                    location: deal.location ?? '',
                  ),
                );
              }).toList());
            }

            return ListView(children: combinedList);
          },
        );
      }),
    );
  }
}
