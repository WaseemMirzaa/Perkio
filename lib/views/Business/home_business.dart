import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/notification_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/business/add_deals.dart';
import 'package:swipe_app/widgets/business_home_list_items.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/primary_layout_widget/primary_layout.dart';
import '../../widgets/custom_appBar/custom_appBar.dart';

class HomeBusiness extends StatefulWidget {
  const HomeBusiness({super.key});

  @override
  State<HomeBusiness> createState() => _HomeBusinessState();
}

class _HomeBusinessState extends State<HomeBusiness> {
  final businessController = Get.put(BusinessController(BusinessServices()));
  final userController = Get.put(UserController(UserServices()));

  final notificationController =
      Get.put(NotificationController()); // Initialize NotificationController

  String searchQuery = '';
  final searchController = TextEditingController();
  late int balance;

  @override
  void initState() {
    super.initState();
    Get.find<NotificationController>();
    getUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  void getUser() {
    String? currentUid = FirebaseAuth.instance.currentUser!.uid;

    userController.gettingUser(currentUid).listen((userModel) {
      if (userModel != null) {
        userController.businessProfile.value = userModel;
        // Update the user profile
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryLayoutWidget(
      header: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: SizedBox(
          height: 20.h,
          child: Obx(() {
            // Use Obx to react to changes in userProfile
            if (userController.businessProfile.value == null) {
              return customAppBar(
                isSearchField: true,
                textController: searchController,
                isSearching: RxBool(searchQuery.isNotEmpty),
                isChangeBusinessLocation: true,

                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                isNotification: false,

                userName: 'Loading...', // Placeholder text
                userLocation: 'Loading...',
              );
            }

            // Use the data from the observable
            final user = userController.businessProfile.value!;
            final userName = user.userName ?? 'Unknown';
            final userLocation = user.address ?? 'No Address';
            final latLog = user.latLong;
            final image = user.image;

            return customAppBar(
                isSearchField: true,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                isChangeBusinessLocation: true,
                isSearching: RxBool(searchQuery.isNotEmpty),
                isNotification: false,
                userName: userName,
                textController: searchController,
                latitude: latLog?.latitude ?? 0.0,
                longitude: latLog?.longitude ?? 0.0,
                userLocation: userLocation,
                userImage: image);
          }),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TempLanguage.lblMyDeals,
                      style: poppinsMedium(fontSize: 18),
                    ),
                    StreamBuilder<UserModel?>(
                        stream: userController
                            .getUserByStream(getStringAsync(SharedPrefKey.uid)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          } else if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          } else {
                            balance = snapshot.data!
                                .balance!; // Get the balance from UserModel
                            return Text("\$$balance Remaining");
                          }
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              StreamBuilder<List<DealModel>>(
                stream: businessController.getMyDeals(
                    getStringAsync(SharedPrefKey.uid),
                    searchQuery: searchQuery),
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

                  final deals = snapshot.data!;

                  // Use a variable to store the balance from the first StreamBuilder
                  int userBalance = 0;

                  // Fetch the user balance from the first StreamBuilder if it's not set
                  final balanceStream = userController
                      .getUserByStream(getStringAsync(SharedPrefKey.uid));

                  // Listen to the balance stream
                  balanceStream.listen((user) {
                    if (user != null) {
                      userBalance =
                          user.balance ?? 0; // Get balance from UserModel
                    }
                  });

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: deals.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final deal = deals[index];
                      return BusinessHomeListItems(
                        dealModel: deal,
                        balance: balance, // Pass the balance here
                      );
                    },
                  );
                },
              ),
              SpacerBoxVertical(height: 10.h),
            ],
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonWidget(
                onSwipe: () {
                  homeController.setImageNull();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDeals()));
                },
                text: TempLanguage.btnLblSwipeToAddDeal),
          ],
        ),
      ),
    );
  }
}
