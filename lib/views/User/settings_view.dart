import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/views/business/profile_settings_business.dart';
import 'package:swipe_app/views/user/user_profile_view.dart';
import 'package:swipe_app/views/help/help_view.dart';
import 'package:swipe_app/views/privacy_policy/privacy_policy.dart';
import 'package:swipe_app/views/terms_and_conditions/terms_conditions.dart';
import 'package:swipe_app/widgets/common/common_widgets.dart';
import 'package:swipe_app/widgets/settings_list_items.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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

  var controller = Get.find<UserController>();

  final promotionalBalanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AppAssets.profileHeader),
            
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 5),
              shrinkWrap: true,
              itemCount: settingsItems.length,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    switch (index) {
                      case 1:
                        {
                          getStringAsync(SharedPrefKey.role) ==
                                  SharedPrefKey.user
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserProfileView()))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileSettingsBusiness()));
                          break;
                        }
                      case 2:
                        {
                          shareDummyLink();
                          break;
                        }
                      case 3:
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsAndConditions()));
                          break;
                        }
                      case 4:
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicy()));
                          break;
                        }
                      case 5:
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HelpView()));
                          break;
                        }
                    }
                  },
                  child: index == 0
                      ? BalanceTile(
                          path: settingsItems[index]['icon'],
                          text:
                              "${settingsItems[index]['title']} ${getIntAsync(UserKey.BALANCE)}",
                          onAdd: () {
                            showBalanceDialog(
                                    context: context,
                                    promotionAmountController:
                                        promotionalBalanceController,
                                    docId: getStringAsync(SharedPrefKey.uid),
                                    fromSettings: true)
                                .then((value) => setState(() {}));
                          })
                      : SettingsListItems(
                          path: settingsItems[index]['icon'],
                          text: settingsItems[index]['title'],
                        )),
            ),
            GestureDetector(
                onTap: () {
                  controller.logout();
                },
                child: const SettingsListItems(
                    path: AppAssets.helpImg, text: 'Logout')),
          ],
        ),
      ),
    );
  }

  void shareDummyLink() {
    const String shareLink = 'https://swipe.com/swip-settings';
    Share.share('Check out this link: $shareLink');
  }
}
