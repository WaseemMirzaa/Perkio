import 'dart:async';
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
import 'package:swipe_app/views/business/profile_settings_business.dart';
import 'package:swipe_app/views/user/user_profile_view.dart';
import 'package:swipe_app/views/help/help_view.dart';
import 'package:nb_utils/nb_utils.dart' as NBUtils;
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

  @override
  void initState() {
    super.initState();
    _userProfileStreamController = StreamController<UserModel>();
    getUser();
  }

  @override
  void dispose() {
    _userProfileStreamController.close();
    super.dispose();
  }

  Future<void> getUser() async {
    try {
      userProfile =
          await controller.getUser(NBUtils.getStringAsync(SharedPrefKey.uid));
      if (userProfile != null) {
        _userProfileStreamController.add(userProfile!);
      } else {
        _userProfileStreamController.addError("User not found.");
      }
    } catch (e) {
      _userProfileStreamController.addError("Failed to fetch user: $e");
    }
  }

  List settingsItems = [
    {
      'icon': AppAssets.moneyIcon,
      'title': 'Wallet Balance:',
    },
    {
      'icon': AppAssets.evaluationImg,
      'title': TempLanguage.txtManageAccount,
    },
    {
      'icon': AppAssets.networkImg,
      'title': TempLanguage.txtShare,
    },
    {
      'icon': AppAssets.privacyImg,
      'title': TempLanguage.txtTermsConditions,
    },
    {
      'icon': AppAssets.insuranceImg,
      'title': TempLanguage.txtPrivacy,
    },
    {
      'icon': AppAssets.helpImg,
      'title': TempLanguage.txtHelp,
    },
  ];

  final promotionalBalanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // If `isUser` is true, remove the first tile from `settingsItems`.
    final List filteredSettingsItems =
        widget.isUser ? settingsItems.sublist(1) : settingsItems;

    final homeController = Get.put(HomeController(HomeServices()));

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
                ClipPath(
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
                          : SizedBox(
                              height: 30.h,
                              width: 100.w,
                              child: Image.network(
                                userProfile.image ?? '',
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
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Image.asset(
                                      AppAssets.imageHeader,
                                      fit: BoxFit.fill,
                                      height: 30.h,
                                      width: 100.w,
                                    ),
                                  );
                                },
                              ),
                            );
                    }),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shrinkWrap: true,
                  itemCount: filteredSettingsItems.length,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    int adjustedIndex = widget.isUser ? index + 1 : index;

                    return GestureDetector(
                      onTap: () {
                        switch (adjustedIndex) {
                          case 0:
                            if (!widget.isUser) {
                              showBalanceDialog(
                                context: context,
                                promotionAmountController:
                                    promotionalBalanceController,
                                docId: getStringAsync(SharedPrefKey.uid),
                                fromSettings: true,
                              ).then((value) => setState(() {}));
                            }
                            break;
                          case 1:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    getStringAsync(SharedPrefKey.role) ==
                                            SharedPrefKey.user
                                        ? const UserProfileView()
                                        : const ProfileSettingsBusiness(),
                              ),
                            );
                            break;
                          case 2:
                            shareDummyLink();
                            break;
                          case 3:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TermsAndConditions(),
                              ),
                            );
                            break;
                          case 4:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicy(),
                              ),
                            );
                            break;
                          case 5:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpView(),
                              ),
                            );
                            break;
                        }
                      },
                      child: !widget.isUser && index == 0
                          ? BalanceTile(
                              path: filteredSettingsItems[index]['icon'],
                              text:
                                  "${filteredSettingsItems[index]['title']} ${getIntAsync(UserKey.BALANCE)}",
                              onAdd: () {
                                showBalanceDialog(
                                  context: context,
                                  promotionAmountController:
                                      promotionalBalanceController,
                                  docId: getStringAsync(SharedPrefKey.uid),
                                  fromSettings: true,
                                ).then((value) => setState(() {}));
                              },
                            )
                          : SettingsListItems(
                              path: filteredSettingsItems[index]['icon'],
                              text: filteredSettingsItems[index]['title'],
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
