import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/services/home_services.dart';

import 'package:swipe_app/views/business/manage_business.dart';
import 'package:swipe_app/views/business/profile_settings_business.dart';
import 'package:swipe_app/views/subscription/subscription_ui.dart';
import 'package:swipe_app/views/user/user_profile_view.dart';
import 'package:swipe_app/views/help/help_view.dart';
import 'package:swipe_app/views/privacy_policy/privacy_policy.dart';
import 'package:swipe_app/views/terms_and_conditions/terms_conditions.dart';
import 'package:swipe_app/widgets/common/common_widgets.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/custom_clipper.dart';
import 'package:swipe_app/widgets/settings_list_items.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';

class SettingsView extends StatefulWidget {
  final bool isUser;

  const SettingsView({super.key, required this.isUser});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late StreamController<UserModel> _userProfileStreamController;
  late UserModel? userProfile;
  var controller = Get.find<UserController>();
  final promotionalBalanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProfileStreamController = StreamController<UserModel>();
    getUser();
  }

  @override
  void dispose() {
    if (!_userProfileStreamController.isClosed) {
      _userProfileStreamController.close();
    }
    super.dispose();
  }

  Future<void> getUser() async {
    try {
      String? currentUseruid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUseruid != null) {
        userProfile = await controller.getUser(currentUseruid);
        if (userProfile != null && !_userProfileStreamController.isClosed) {
          _userProfileStreamController.add(userProfile!);
        } else if (!_userProfileStreamController.isClosed) {
          _userProfileStreamController.addError("User not found.");
        }
      }
    } catch (e) {
      if (!_userProfileStreamController.isClosed) {
        _userProfileStreamController.addError("Failed to fetch user: $e");
      }
    }
  }

  // Method to generate settings items based on user type
  List _getSettingsItems() {
    if (!widget.isUser) {
      // Business View
      return [
        {'icon': AppAssets.moneyIcon, 'title': 'Wallet Balance:', 'type': 'balance'},
        {'icon': AppAssets.walletImg, 'title': 'Manage Business', 'type': 'manage_business'},
        {'icon': AppAssets.evaluationImg, 'title': TempLanguage.txtManageAccount, 'type': 'manage_account'},
        {'icon': AppAssets.networkImg, 'title': TempLanguage.txtShare, 'type': 'share'},
        {'icon': AppAssets.privacyImg, 'title': TempLanguage.txtTermsConditions, 'type': 'terms'},
        {'icon': AppAssets.insuranceImg, 'title': TempLanguage.txtPrivacy, 'type': 'privacy'},
        {'icon': AppAssets.helpImg, 'title': TempLanguage.txtHelp, 'type': 'help'},
        
      ];
    } else {
      // User View
      return [
        
        {'icon': AppAssets.evaluationImg, 'title': TempLanguage.txtManageAccount, 'type': 'manage_account'},
        {'icon': AppAssets.subscriptionImg, 'title': 'Subscription', 'type': 'subscription'},
        {'icon': AppAssets.networkImg, 'title': TempLanguage.txtShare, 'type': 'share'},
        {'icon': AppAssets.privacyImg, 'title': TempLanguage.txtTermsConditions, 'type': 'terms'},
        {'icon': AppAssets.insuranceImg, 'title': TempLanguage.txtPrivacy, 'type': 'privacy'},
        {'icon': AppAssets.helpImg, 'title': TempLanguage.txtHelp, 'type': 'help'},
        
      ];
    }
  }

  // Method to handle navigation based on item type
  void _handleNavigation(String type) {
    switch (type) {
      case 'balance':
        showBalanceDialog(
          context: context,
          promotionAmountController: promotionalBalanceController,
          docId: getStringAsync(SharedPrefKey.uid),
          fromSettings: true,
        ).then((value) => setState(() {}));
        break;
      case 'manage_business':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BusinessManagementScreen(),
          ),
        );
        break;
      case 'manage_account':
      widget.isUser ? 

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserProfileView(),
          ),
        )
        :
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileSettingsBusiness(),
          ),
        )

        ;
        break;
      case 'subscription':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VendorSubscriptionUI(),
          ),
        );
        break;
      case 'share':
        shareDummyLink();
        break;
      case 'terms':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TermsAndConditions(),
          ),
        );
        break;
      case 'privacy':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrivacyPolicy(),
          ),
        );
        break;
      case 'help':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HelpView(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController(HomeServices()));
    final settingsItems = _getSettingsItems();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: StreamBuilder<UserModel>(
        stream: _userProfileStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: circularProgressBar());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }
          final userProfile = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                userProfile.image != null && userProfile.image!.isNotEmpty
                    ? ClipPath(
                        clipper: CustomMessageClipper(),
                        child: SizedBox(
                          height: 210,
                          width: double.infinity,
                          child: Obx(() {
                            return (homeController.pickedImage != null)
                                ? Image.file(
                                    homeController.pickedImage!,
                                    height: 30.h,
                                    width: 100.w,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    userProfile.image!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.gradientEndColor,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                  );
                          }),
                        ),
                      )
                    : Image.asset(
                        AppAssets.imageHeader,
                        fit: BoxFit.cover,
                      ),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shrinkWrap: true,
                  itemCount: settingsItems.length,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = settingsItems[index];
                    return GestureDetector(
                      onTap: () => _handleNavigation(item['type']),
                      child: item['type'] == 'balance'
                          ? BalanceTile(
                              path: item['icon'],
                              text:
                                  "${item['title']} \$${getIntAsync(UserKey.BALANCE)}",
                              onAdd: () => _handleNavigation('balance'),
                            )
                          : SettingsListItems(
                              path: item['icon'],
                              text: item['title'],
                            ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    controller.clearTextFields();
                    await controller.logout();
                  },
                  child: const SettingsListItems(
                    path: AppAssets.helpImg,
                    text: 'Logout',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void shareDummyLink() {
    const String shareLink = 'https://swipe.com/swip-settings';
    Share.share('Check out this link: $shareLink');
  }
}