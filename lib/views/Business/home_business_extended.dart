import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/views/business/add_deals.dart';
import 'package:swipe_app/widgets/business_home_list_items.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/widgets/primary_layout_widget/primary_layout.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class PromotedDealView extends StatefulWidget {
  const PromotedDealView({super.key});

  @override
  State<PromotedDealView> createState() => _PromotedDealViewState();
}

class _PromotedDealViewState extends State<PromotedDealView> {
  final businessController = Get.put(BusinessController(BusinessServices()));

  @override
  Widget build(BuildContext context) {
    return PrimaryLayoutWidget(
        // header: SizedBox(height: 16.h,
        // child: customAppBar(),
        header: SizedBox(
          height: 16.40.h,
          child: PreferredSize(
            preferredSize: Size.fromHeight(12.h),
            child: Obx(() {
              // Use Obx to react to changes in userProfile
              if (userController.userProfile.value == null) {
                return customAppBar(
                  userName: 'Loading...', // Placeholder text
                  userLocation: 'Loading...',
                  isNotification: false,
                );
              }

              // Use the data from the observable
              final user = userController.userProfile.value!;
              final userName = user.userName ?? 'Unknown';
              final userLocation = user.address ?? 'No Address';
              final latLog = user.latLong;

              return customAppBar(
                userName: userName,
                latitude: latLog?.latitude ?? 0.0,
                longitude: latLog?.longitude ?? 0.0,
                userLocation: userLocation,
                isNotification: false,
              );
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
                  height: 12.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    TempLanguage.lblPromotedDeal,
                    style: poppinsMedium(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                StreamBuilder<List<DealModel>>(
                    stream: businessController
                        .getMyPromotedDeal(getStringAsync(SharedPrefKey.uid)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: circularProgressBar());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No promoted deals available'));
                      }

                      final deals = snapshot.data!;
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: deals.length,
                          itemBuilder: (context, index) {
                            final promotedDeals = deals[index];
                            return BusinessHomeListItems(
                                dealModel: promotedDeals);
                          });
                    }),
                SpacerBoxVertical(height: 10.h),
              ],
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ButtonWidget(
              onSwipe: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddDeals()));
              },
              text: TempLanguage.btnLblSwipeToAddDeal),
        ));
  }
}
