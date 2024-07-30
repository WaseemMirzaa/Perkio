import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/views/Business/add_deals.dart';
import 'package:skhickens_app/views/Business/add_rewards.dart';
import 'package:skhickens_app/views/Business/home_business.dart';
import 'package:skhickens_app/views/Business/home_business_extended.dart';
import 'package:skhickens_app/views/Business/profile_settings_business.dart';
import 'package:skhickens_app/views/Business/rewards_business.dart';
import 'package:skhickens_app/views/Business/subscription_plan.dart';
import 'package:skhickens_app/views/User/business_detail.dart';
import 'package:skhickens_app/views/User/deal_detail.dart';
import 'package:skhickens_app/views/User/favourites.dart';
import 'package:skhickens_app/views/User/home_user.dart';
import 'package:skhickens_app/views/User/location_change_screen.dart';
import 'package:skhickens_app/views/auth/add_bussiness_details_view.dart';
import 'package:skhickens_app/views/auth/login_view.dart';
import 'package:skhickens_app/views/User/user_profile_view.dart';
import 'package:skhickens_app/views/User/settings_view.dart';
import 'package:skhickens_app/views/User/reward_detail.dart';
import 'package:skhickens_app/views/User/reward_redeem_detail.dart';
import 'package:skhickens_app/views/User/scan_screen.dart';
import 'package:skhickens_app/views/auth/signup_view.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/views/notifications/notifications_view.dart';
import 'package:skhickens_app/views/role_selection/role_selection_view.dart';
import 'package:skhickens_app/views/splash_screen.dart';
import 'package:skhickens_app/views/privacy_policy.dart';
import 'package:skhickens_app/views/terms_conditions.dart';

class AppRoutes {
  static const String splash = '/';
  static const String selection = '/selection';
  static const String addDeal = '/addDeal';
  static const String addReward = '/addReward';
  static const String homeBusinessExtended = '/homeBusinessExtended';
  static const String homeBusiness = '/homeBusiness';
  static const String profileSettingsBusiness = '/profileSettingsBusiness';
  static const String rewardsBusiness = '/rewardsBusiness';
  static const String subscriptionPlan = '/subscriptionPlan';
  static const String businessDetail = '/businessDetail';
  static const String dealDetail = '/dealDetail';
  static const String notifications = '/notifications';
  static const String favouritesScreen = '/favouritesScreen';
  static const String homeUser = '/homeUser';
  static const String locationChangeScreen = '/locationChangeScreen';
  static const String loginUser = '/loginUser';
  static const String userProfileView = '/userProfileView';
  static const String settingsView = '/settingsView';
  static const String rewardDetail = '/rewardDetail';
  static const String rewardRedeemDetail = '/rewardRedeemDetail';
  static const String scanScreen = '/scanScreen';
  static const String signupUser = '/signupUser';
  static const String privacyPolicy = '/privacyPolicy';
  static const String termsAndConditions = '/termsAndConditions';
  static const String bottomBarView = '/bottomBarView';
  static const String addBusinessInfo = '/addBusinessInfo';


  static List<GetPage> routes = [
    GetPage(name: splash, page: () =>  const SplashScreen()),
    GetPage(name: selection, page: () => const SelectionScreen()),
    GetPage(name: addDeal, page: () => const AddDeals()),
    GetPage(name: addReward, page: () => const AddRewards()),
    GetPage(name: homeBusinessExtended, page: () => const HomeBusinessExtended()),
    GetPage(name: homeBusiness, page: () => const HomeBusiness()),
    GetPage(name: profileSettingsBusiness, page: () => const ProfileSettingsBusiness()),
    GetPage(name: rewardsBusiness, page: () => const RewardsBusiness()),
    GetPage(name: subscriptionPlan, page: () => SubscriptionPlan()),
    GetPage(name: businessDetail, page: () => const BusinessDetail()),
    GetPage(name: dealDetail, page: () => const DealDetail()),
    GetPage(name: favouritesScreen, page: () => FavouritesScreen()),
    GetPage(name: homeUser, page: () => const HomeUser()),
    GetPage(name: locationChangeScreen, page: () => LocationChangeScreen()),
    GetPage(name: loginUser, page: () => const LoginView()),
    GetPage(name: userProfileView, page: () => const UserProfileView()),
    GetPage(name: settingsView, page: () => const SettingsView()),
    GetPage(name: rewardDetail, page: () => const RewardDetail()),
    GetPage(name: rewardRedeemDetail, page: () => const RewardRedeemDetail()),
    GetPage(name: notifications, page: () => const NotificationsView()),
    GetPage(name: bottomBarView, page: () => BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false)),
    GetPage(name: scanScreen, page: () => const ScanScreen()),
    GetPage(name: signupUser, page: () => const SignupView()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicy()),
    GetPage(name: termsAndConditions, page: () => const TermsAndConditions()),
    GetPage(name: addBusinessInfo, page: () => const AddBusinessDetailsView())
  ];
}