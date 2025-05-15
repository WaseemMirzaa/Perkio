import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_app/controllers/subscription_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

class VendorSubscriptionUI extends StatelessWidget {
  final SubscriptionController subscriptionController = Get.put(SubscriptionController());
  final bool fromSignUp;

  VendorSubscriptionUI({super.key, this.fromSignUp = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Premium Plans',
          style: poppinsMedium(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () => subscriptionController.restorePurchases(),
            child: Text(
              'Restore',
              style: poppinsRegular(fontSize: 14, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (subscriptionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildFeaturesList(),
              const SizedBox(height: 24),
              _buildSubscriptionPlans(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            // gradient: const LinearGradient(
            //   colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                'Unlock Premium Features',
                style: poppinsBold(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Get unlimited access to all premium features and grow your business',
                style: poppinsRegular(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionPlans() {
    return Column(
      children: [
        // Active Subscription Section
        // Obx(() => subscriptionController.isSubscribed.value == true
        //     ? Container(
        //         padding: const EdgeInsets.all(16),
        //         decoration: BoxDecoration(
        //           color: Colors.green.withOpacity(0.1),
        //           borderRadius: BorderRadius.circular(16),
        //         ),
        //         child: Column(
        //           children: [
        //             Text(
        //               'Active Subscription',
        //               style: poppinsBold(fontSize: 20),
        //             ),
        //             const SizedBox(height: 8),
        //             Text(
        //               subscriptionController.subscriptionStatus.value ?? '',
        //               style: poppinsRegular(fontSize: 16),
        //             ),
        //             const SizedBox(height: 16),
        //             Obx(() => subscriptionController.isCancellingSubscription.value
        //                 ? Row(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: [
        //                       // const SizedBox(
        //                       //   width: 16,
        //                       //   height: 16,
        //                       //   child: CircularProgressIndicator(
        //                       //     strokeWidth: 2,
        //                       //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //                       //   ),
        //                       // ),
        //                       const SizedBox(width: 8),
        //                       Text(
        //                         "Your subscription has been canceled.\nPlease wait a few minutes for the cancellation..",
        //                         maxLines: 2,
        //                         textAlign: TextAlign.center,
        //                         style: poppinsMedium(fontSize: 12, color: Colors.red),
        //                       ),
        //                     ],
        //                   )
        //                 : Container(
        //                     // width: double.infinity,
        //                     decoration: BoxDecoration(
        //                       gradient: const LinearGradient(
        //                         colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
        //                         begin: Alignment.centerLeft,
        //                         end: Alignment.centerRight,
        //                       ),
        //                       borderRadius: BorderRadius.circular(12),
        //                     ),
        //                     child: ElevatedButton(
        //                       onPressed: subscriptionController.isCancellingSubscription.value
        //                           ? null // Disable button when cancelling
        //                           : () => subscriptionController.cancelSubscription(),
        //                       style: ElevatedButton.styleFrom(
        //                         backgroundColor: Colors.transparent,
        //                         shadowColor: Colors.transparent,
        //                         // padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
        //                         shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(12),
        //                         ),
        //                       ),
        //                       child: Text(
        //                         'Manage Subscription',
        //                         style: poppinsMedium(fontSize: 16, color: Colors.white),
        //                       ),
        //                     ),
        //                   )),
        //           ],
        //         ),
        //       )
        //     : const SizedBox.shrink()),

        // No Plans Available Message
        Obx(() => subscriptionController.offering.value == null
            ? Center(
                child: Text(
                  'No subscription plans available',
                  style: poppinsMedium(fontSize: 16),
                ),
              )
            : const SizedBox.shrink()),
        const SizedBox(height: 16),

        // Monthly Plan
        Obx(() {
          final isSubscribed = subscriptionController.isSubscribed.value;
          final subscriptionType = subscriptionController.currentSubscriptionType.value;
          print(
              "Monthly plan UI check: isSubscribed=$isSubscribed, subscriptionType=$subscriptionType");

          return isSubscribed == true && subscriptionType == 'yearly'
              ? const SizedBox.shrink() // Hide if yearly subscription is active
              : subscriptionController.offering.value?.getPackage('\$rc_monthly') != null
                  ? _buildPlanCard(
                      package: subscriptionController.offering.value!.getPackage('\$rc_monthly'),
                      title: 'Monthly Premium',
                      description: 'Perfect for trying out our premium features',
                      isPopular: false,
                      subscriptionType: 'monthly',
                    )
                  : const SizedBox.shrink();
        }),

        const SizedBox(height: 16),

        // Yearly Plan
        Obx(() {
          final isSubscribed = subscriptionController.isSubscribed.value;
          final subscriptionType = subscriptionController.currentSubscriptionType.value;
          print(
              "Yearly plan UI check: isSubscribed=$isSubscribed, subscriptionType=$subscriptionType");

          return isSubscribed == true && subscriptionType == 'monthly'
              ? const SizedBox.shrink() // Hide if monthly subscription is active
              : subscriptionController.offering.value?.getPackage('\$rc_annual') != null
                  ? _buildPlanCard(
                      package: subscriptionController.offering.value!.getPackage('\$rc_annual'),
                      title: 'Yearly Premium',
                      description: 'Our best value plan with 2 months free',
                      isPopular: true,
                      subscriptionType: 'yearly',
                    )
                  : const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildPlanCard({
    required Package? package,
    required String title,
    required String description,
    required bool isPopular,
    required String subscriptionType,
  }) {
    if (package == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? AppColors.gradientStartColor : Colors.grey.shade300,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gradientStartColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isPopular ? 14 : 15),
                  topRight: Radius.circular(isPopular ? 14 : 15),
                ),
              ),
              child: Text(
                'MOST POPULAR',
                style: poppinsBold(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: poppinsBold(fontSize: 20),
                    ),
                    subscriptionController.isSubscribed.value
                        ? Icon(Icons.circle,
                            color: isPopular
                                ? AppColors.gradientStartColor
                                : AppColors.gradientEndColor,
                            size: 8)
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: poppinsRegular(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.storeProduct.priceString,
                      style: poppinsBold(fontSize: 32),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subscriptionType == 'yearly' ? '/year' : '/month',
                      style: poppinsRegular(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                // const SizedBox(height: 20),

                // Free Trial Section
                if (!subscriptionController.isSubscribed.value &&
                    !subscriptionController.hasTrialExpired.value)
                  Container(
                    // margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withOpacity(0.1),
                      // color: isPopular ? AppColors.gradientStartColor.withOpacity(0.1) : Colors.grey.shade300,

                      borderRadius: BorderRadius.circular(12),
                      // border: Border.all(
                      //   // color: AppColors.gradientStartColor,
                      //   color: isPopular ? AppColors.gradientStartColor.withOpacity(0.1) : Colors.grey.shade300,
                      //
                      // width: 1,
                      // ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //  Icon(
                            //   Icons.star,
                            //   // color: AppColors.gradientStartColor,
                            //   color: isPopular ? AppColors.gradientStartColor : Colors.blue,
                            //
                            //   size: 24,
                            // ),
                            // const SizedBox(width: 8),
                            Text(
                              'Free for 7 Days',
                              style: poppinsRegular(fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 12),
                        // Text(
                        //   'Start your free trial now and get access to all premium features. No payment required.',
                        //   style: poppinsRegular(fontSize: 12),
                        //   textAlign: TextAlign.center,
                        // ),
                        // const SizedBox(height: 16),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     onPressed: () async {
                        //       try {
                        //         // Get the trial package
                        //         final trialPackage = subscriptionController
                        //             .offering.value?.getPackage('\$rc_trial');
                        //
                        //         if (trialPackage != null) {
                        //           bool? confirm = await Get.dialog<bool>(
                        //             AlertDialog(
                        //               title: Text(
                        //                 'Start Free Trial',
                        //                 style: poppinsBold(fontSize: 18),
                        //               ),
                        //               content: Column(
                        //                 mainAxisSize: MainAxisSize.min,
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     'Start your 7-day free trial with full access to:',
                        //                     style: poppinsRegular(fontSize: 12),
                        //                   ),
                        //                   const SizedBox(height: 12),
                        //                   _buildBulletPoint('Unlimited Deal Scanning'),
                        //                   _buildBulletPoint('Deal Notifications'),
                        //                   _buildBulletPoint('Area-Based Alerts'),
                        //                   _buildBulletPoint('Featured Listings'),
                        //                   _buildBulletPoint('Premium Support'),
                        //                   const SizedBox(height: 12),
                        //                   Text(
                        //                     'After the trial ends, you\'ll be charged ${trialPackage.storeProduct.priceString}/month unless you cancel.',
                        //                     style: poppinsRegular(fontSize: 14),
                        //                   ),
                        //                 ],
                        //               ),
                        //               actions: [
                        //                 TextButton(
                        //                   onPressed: () => Get.back(result: false),
                        //                   child: Text(
                        //                     'Not Now',
                        //                     style: poppinsRegular(fontSize: 14),
                        //                   ),
                        //                 ),
                        //                 TextButton(
                        //                   onPressed: () => Get.back(result: true),
                        //                   child: Text(
                        //                     'Start Trial',
                        //                     style: poppinsMedium(
                        //                       fontSize: 14,
                        //                       color: AppColors.gradientStartColor,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           );
                        //
                        //           if (confirm == true) {
                        //             await subscriptionController
                        //                 .purchaseSubscription(trialPackage);
                        //           }
                        //         }
                        //       } catch (e) {
                        //         // Error handling is done in the controller
                        //       }
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: isPopular ? AppColors.gradientStartColor : Colors.blue,
                        //       padding: const EdgeInsets.symmetric(vertical: 16),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //     ),
                        //     child: Text(
                        //       'Start Free Trial',
                        //       style: poppinsMedium(fontSize: 16, color: Colors.white),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     colors: subscriptionController.isSubscribed.value
                  //         ? [AppColors.redColor, const Color.fromARGB(255, 5, 4, 4)]
                  //         : [AppColors.gradientStartColor, AppColors.gradientEndColor],
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //   ),
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                  decoration: BoxDecoration(
    color: AppColors.primaryColor,
    borderRadius: BorderRadius.circular(12),
  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check subscription status first
                      if (subscriptionController.isSubscribed.value) {
                        // Show cancellation confirmation dialog
                        bool? confirmCancel = await Get.dialog<bool>(
                          AlertDialog(
                            title: Text(
                              'Cancel Subscription',
                              style: poppinsBold(fontSize: 18),
                            ),
                            content: Text(
                              'Are you sure you want to cancel your subscription? You will continue to have access until the end of your current billing period.',
                              style: poppinsRegular(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: Text(
                                  'Keep Subscription',
                                  style: poppinsRegular(fontSize: 14),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: Text(
                                  'Cancel Subscription',
                                  style: poppinsMedium(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmCancel == true) {
                          try {
                            await subscriptionController.cancelSubscription();
                          } catch (e) {
                            // Error handling is done in the controller
                          }
                        }
                        return;
                      }

                      // Show confirmation dialog with trial information for new users
                      // bool? confirm = await Get.dialog<bool>(
                      //   AlertDialog(
                      //     title: Text(
                      //       'Start 7-Day Free Trial',
                      //       style: poppinsBold(fontSize: 18),
                      //     ),
                      //     content: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'Try all premium features free for 7 days:',
                      //           style: poppinsRegular(fontSize: 16),
                      //         ),
                      //         const SizedBox(height: 16),
                      //         _buildBulletPoint('Unlimited Deal Scanning'),
                      //         _buildBulletPoint('Deal Notifications'),
                      //         _buildBulletPoint('Area-Based Alerts'),
                      //         _buildBulletPoint('Featured Listings'),
                      //         _buildBulletPoint('Premium Support'),
                      //         const SizedBox(height: 16),
                      //         Text(
                      //           'After the trial ends, you\'ll be automatically subscribed to:',
                      //           style: poppinsMedium(fontSize: 14),
                      //         ),
                      //         const SizedBox(height: 8),
                      //         Text(
                      //           '${package.storeProduct.priceString}/${subscriptionType == 'yearly' ? 'year' : 'month'}',
                      //           style: poppinsBold(fontSize: 14),
                      //         ),
                      //         const SizedBox(height: 8),
                      //         Text(
                      //           'Cancel anytime during the trial - no charge.',
                      //           style: poppinsRegular(fontSize: 12),
                      //         ),
                      //       ],
                      //     ),
                      //     actions: [
                      //       TextButton(
                      //         onPressed: () => Get.back(result: false),
                      //         child: Text(
                      //           'Not Now',
                      //           style: poppinsRegular(fontSize: 14),
                      //         ),
                      //       ),
                      //       TextButton(
                      //         onPressed: () => Get.back(result: true),
                      //         child: Text(
                      //           'Start Free Trial',
                      //           style: poppinsMedium(
                      //             fontSize: 14,
                      //             color: AppColors.gradientStartColor,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // );
                      //
                      // if (confirm == true) {
                      //   try {
                      //     await subscriptionController.purchaseSubscription(package);
                      //   } catch (e) {
                      //     // Error handling is done in the controller
                      //   }
                      // }
                      await subscriptionController.purchaseSubscription(package);
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: isPopular ? AppColors.gradientStartColor : Colors.blue,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.transparent,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(() {
                      final isSubscribed = subscriptionController.isSubscribed.value;
                      return Text(
                        isSubscribed ? 'Cancel' : 'Subscribe Now',
                        style: poppinsMedium(fontSize: 16, color: Colors.white),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': Icons.notifications_active_outlined,
        'title': 'Deal Notifications',
        'description': 'Get instant notifications for new deals and rewards in your area',
      },
      {
        'icon': Icons.qr_code_scanner_outlined,
        'title': 'Unlimited Deal Scanning',
        'description': 'Scan unlimited deals and rewards',
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Area-Based Alerts',
        'description': 'Stay updated with deals near you',
      },
      {
        'icon': Icons.star_outline,
        'title': 'Featured Listings',
        'description': 'Get more visibility for your deals',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: poppinsBold(fontSize: 20),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => _buildFeatureItem(feature)),
      ],
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gradientStartColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: AppColors.gradientStartColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'] as String,
                  style: poppinsMedium(fontSize: 16),
                ),
                Text(
                  feature['description'] as String,
                  style: poppinsRegular(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.gradientStartColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: poppinsRegular(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
