import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/views/business/edit_my_deal.dart';
import 'package:swipe_app/widgets/common/common_widgets.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';

class BusinessHomeListItems extends StatefulWidget {
  BusinessHomeListItems({super.key, required this.dealModel, this.balance});
  DealModel dealModel;
  int? balance = 0;

  @override
  State<BusinessHomeListItems> createState() => _BusinessHomeListItemsState();
}

class _BusinessHomeListItemsState extends State<BusinessHomeListItems> {
  final businessController = Get.put(BusinessController(BusinessServices()));
  final homeController = Get.put(HomeController(HomeServices()));
  final promotionAmountController = TextEditingController();
  int apc = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
      child: Container(
        height: widget.dealModel.isPromotionStar! ? 23.h : 18.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: AppColors.borderColor),
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3))
            ]),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxHorizontal(width: 10),
                Container(
                    height: 14.h,
                    width: 14.h,
                    margin: EdgeInsets.only(top: 10.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(14.sp),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.blackColor.withOpacity(0.16),
                            offset: const Offset(0, 3),
                            blurRadius: 6.5),
                      ],
                      image: DecorationImage(
                          image: NetworkImage(widget.dealModel.image!),
                          fit: BoxFit.cover),
                    )),
                const SpacerBoxHorizontal(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacerBoxVertical(height: 10),
                      SizedBox(
  width: 120,
  child: Text(
    widget.dealModel.dealName.capitalizeEachWord(),
    style: poppinsMedium(fontSize: 13.sp),
    overflow: TextOverflow.ellipsis,
    maxLines: 1, 
  ),
),
                      const SpacerBoxVertical(height: 5),
                      Text(
                        widget.dealModel.companyName ?? '',
                        style: poppinsRegular(
                            fontSize: 10.sp, color: AppColors.hintText),
                      ),
                      const SpacerBoxVertical(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.hintText,
                            size: 12.sp,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.dealModel.location ?? "",
                                    style: poppinsRegular(
                                      fontSize: 10.sp,
                                      color: AppColors.hintText,
                                    ),
                                    maxLines: 1, // Set the max lines you want
                                    overflow: TextOverflow
                                        .ellipsis, // Add ellipsis if the text overflows
                                  ),
                                ),
                                const SpacerBoxHorizontal(width: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SpacerBoxVertical(height: 5),
                      Text(
                        '${widget.dealModel.noOfUsedTellNow} People have used this deal',
                        style: poppinsRegular(
                          fontSize: 10.sp,
                          color: AppColors.hintText,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "USES ${widget.dealModel.uses}",
                          style: poppinsMedium(fontSize: 13.sp),
                        ),
                      ),
                      const SpacerBoxVertical(height: 5),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Get.to(
                              () => EditMyDeals(dealModel: widget.dealModel));
                        },
                        icon: ImageIcon(const AssetImage(AppAssets.editImg),
                            size: 15.sp, color: AppColors.blackColor)),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                      'Deal Deletion',
                                      style: poppinsMedium(fontSize: 14.sp),
                                    ),
                                    content: const Text(
                                        'Are you sure you want to delete the deal?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            await businessController
                                                .deleteDeal(
                                                    widget.dealModel.dealId!,
                                                    widget.dealModel.image!)
                                                .then((value) => Get.back());
                                          },
                                          child: const Text('Delete')),
                                    ],
                                  ));
                        },
                        icon: ImageIcon(const AssetImage(AppAssets.deleteImg),
                            size: 15.sp, color: AppColors.redColor)),
                  ],
                ),
                const SizedBox(),
                const SizedBox(),
                widget.dealModel.isPromotionStar!
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () async {
                          String? currentUID =
                              FirebaseAuth.instance.currentUser!.uid;

                          bool? balanceStatus = await homeController.checkBalance(
                              currentUID); // Replace currentUserUid with the actual user UID

                          log('💥💥💥💥💥 Balance: $balanceStatus');
                          if (balanceStatus == true) {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Deal Promotion',
                                    style: poppinsBold(fontSize: 15.sp)),
                                content: const Text(
                                    'Are you sure you want to promote this deal?'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        Get.back();
                                      },
                                      child: const Text('No')),
                                  TextButton(
                                      onPressed: () async {
                                        await homeController.updateCollection(
                                            widget.dealModel.dealId!,
                                            CollectionsKey.DEALS, {
                                          DealKey.ISPROMOTIONSTART: true
                                        }).then((value) => Get.back());
                                      },
                                      child: const Text('Yes')),
                                ],
                              ),
                            );
                          } else {
                            print('-----${widget.dealModel.dealId!}');
                            showBalanceDialog(
                                context: context,
                                promotionAmountController:
                                    promotionAmountController,
                                docId: widget.dealModel.dealId!);
                          }
                        },
                        child: Container(
                          height: 2.5.h,
                          width: 16.w,
                          margin: const EdgeInsets.only(
                              top: 30, left: 10, right: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.gradientStartColor,
                                AppColors.gradientEndColor
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                              child: Text(
                            TempLanguage.txtPromote,
                            style: poppinsRegular(
                                fontSize: 9, color: AppColors.whiteColor),
                          )),
                        ),
                      ),
                widget.dealModel.isPromotionStar!
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              height: 1,
                              color: AppColors.borderColor,
                            ),
                          ),
                          const SpacerBoxVertical(height: 5),
                          Row(
                            children: [
                              const SpacerBoxHorizontal(width: 12),
                              Image.asset(
                                AppAssets.thumbsImg,
                                scale: 3,
                              ),
                              const SpacerBoxHorizontal(width: 5),
                              Column(
                                children: [
                                  Text(
                                    widget.dealModel.likes.toString(),
                                    style: poppinsMedium(fontSize: 10),
                                  ),
                                  Text(
                                    TempLanguage.txtLikes,
                                    style: poppinsMedium(
                                        fontSize: 10,
                                        color: AppColors.hintText),
                                  ),
                                ],
                              ),
                              const SpacerBoxHorizontal(width: 20),
                              Image.asset(
                                AppAssets.viewImg,
                                scale: 3,
                              ),
                              const SpacerBoxHorizontal(width: 5),
                              Column(
                                children: [
                                  Text(
                                    widget.dealModel.views.toString(),
                                    style: poppinsMedium(fontSize: 10),
                                  ),
                                  Text(
                                    TempLanguage.txtViews,
                                    style: poppinsMedium(
                                        fontSize: 10,
                                        color: AppColors.hintText),
                                  ),
                                ],
                              ),
                              const Expanded(
                                  child: SpacerBoxHorizontal(width: 5)),
                              GestureDetector(
                                onTap: () {
                                  showAdaptiveDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(
                                              'Stop Promotion',
                                              style:
                                                  poppinsBold(fontSize: 14.sp),
                                            ),
                                            content: Text(
                                              'Do you really want to stop promotion of the deal',
                                              style: poppinsRegular(
                                                  fontSize: 12.sp),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text('No')),
                                              TextButton(
                                                  onPressed: () async {
                                                    await homeController
                                                        .updateCollection(
                                                            widget.dealModel
                                                                .dealId!,
                                                            CollectionsKey
                                                                .DEALS,
                                                            {
                                                          DealKey.ISPROMOTIONSTART:
                                                              false,
                                                          DealKey.VIEWS: 0,
                                                        }).then((value) =>
                                                            Get.back());
                                                  },
                                                  child: const Text('Yes')),
                                            ],
                                          ));

                                  //final id = await StripePayment.createStripeCustomer(email: user.email ?? '');
                                  //print('iii ${id}');
                                  //stripeId = cus_Qednk9oJzmhpIy;

                                  // int amount = 20 * 100; ///$20 = 20 * 100
                                  // if (amount.isEven) {
                                  //   await StripePayment.initPaymentSheet(amount: amount, customerId: 'cus_Qednk9oJzmhpIy');
                                  // }
                                },
                                child: Container(
                                  height: 2.5.h,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.gradientStartColor,
                                        AppColors.gradientEndColor
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Text(
                                      TempLanguage.txtStopPromotion,
                                      style: poppinsRegular(
                                          fontSize: 8,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                              const SpacerBoxHorizontal(width: 12),
                            ],
                          ),
                          const SpacerBoxVertical(height: 5),
                        ],
                      )
                    : const SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }

  bool isValidDecimal(String value) {
    final regex = RegExp(r'^\d+(\.\d+)?$');
    return regex.hasMatch(value);
  }
}
