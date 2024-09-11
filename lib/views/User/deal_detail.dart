import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/ui_controllers/business_detail_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/congratulation_dialog.dart';
import 'package:swipe_app/widgets/detail_tile.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

import '../../core/utils/constants/app_const.dart';
import '../bottom_bar_view/bottom_bar_view.dart';

class DealDetail extends StatefulWidget {
  final DealModel? deal;

  const DealDetail({super.key, this.deal});

  @override
  State<DealDetail> createState() => _DealDetailState();
}

class _DealDetailState extends State<DealDetail> {
  final BusinessDetailController controller =
      Get.put(BusinessDetailController());
  bool canSwipe = true;

  @override
  void initState() {
    super.initState();
    _checkUserUsage();
  }

  // Method to check if the user can still use the deal
  Future<void> _checkUserUsage() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentReference dealRef =
        FirebaseFirestore.instance.collection('deals').doc(widget.deal!.dealId);

    // Get the current deal document
    DocumentSnapshot dealSnapshot = await dealRef.get();
    if (dealSnapshot.exists) {
      Map<String, dynamic> dealData =
          dealSnapshot.data() as Map<String, dynamic>;

      // Get the 'usedBy' map
      Map<String, int> usedBy = Map<String, int>.from(dealData['usedBy'] ?? {});

      // Check if the user's usage equals or exceeds the deal's maximum allowed uses
      if ((usedBy[userId] ?? 0) >= widget.deal!.uses!) {
        setState(() {
          canSwipe = false; // Disable swipe if the user reached the limit
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              const SpacerBoxVertical(height: 20),
              DetailTile(
                businessId: deal!.businessId,
              ),
              const SpacerBoxVertical(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.dealName ?? TempLanguage.txtDealName,
                          style: poppinsMedium(fontSize: 13.sp),
                        ),
                        Text(
                          deal.location ?? TempLanguage.txtMilesAway,
                          style: poppinsRegular(
                            fontSize: 10.sp,
                            color: AppColors.hintText,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'USES ${deal.uses}',
                      style: poppinsMedium(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SpacerBoxVertical(height: 20),
              if (deal.image!.isEmpty)
                Image.asset(
                  deal.image ?? AppAssets.foodImg,
                  scale: 3,
                ),
              Image.network(
                deal.image ?? '',
                scale: 3,
              ),
              const SpacerBoxVertical(height: 20),

              // Conditionally show the swipe button if the user can still swipe
              if (canSwipe)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ButtonWidget(
                    onSwipe: () async {
                      // Call the updateUsedBy method with the deal's ID
                      await controller.updateUsedBy(deal.dealId!);
                      showCongratulationDialog(onDone: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationService(
                              child: BottomBarView(
                                isUser: getStringAsync(SharedPrefKey.role) ==
                                        SharedPrefKey.user
                                    ? true
                                    : false,
                              ),
                            ),
                          ),
                          (route) => false,
                        );
                      });
                    },
                    text: TempLanguage.btnLblSwipeToRedeem,
                  ),
                ),
              if (!canSwipe)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "You have used this deal the maximum allowed times.",
                    style: poppinsRegular(
                      fontSize: 12.sp,
                      color: AppColors.hintText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
