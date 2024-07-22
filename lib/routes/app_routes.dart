import 'package:get/get.dart';
import 'package:skhickens_app/views/Business/add_deals.dart';
import 'package:skhickens_app/views/Business/add_rewards.dart';
import 'package:skhickens_app/views/Business/home_business.dart';
import 'package:skhickens_app/views/Business/home_business_extended.dart';
import 'package:skhickens_app/views/Business/login_business.dart';
import 'package:skhickens_app/views/Business/profile_settings_business.dart';
import 'package:skhickens_app/views/Business/rewards_business.dart';
import 'package:skhickens_app/views/Business/signup_business.dart';
import 'package:skhickens_app/views/Business/subscription_plan.dart';
import 'package:skhickens_app/views/User/business_detail.dart';
import 'package:skhickens_app/views/User/deal_detail.dart';
import 'package:skhickens_app/views/User/favourites.dart';
import 'package:skhickens_app/views/User/home_user.dart';
import 'package:skhickens_app/views/User/location_change_screen.dart';
import 'package:skhickens_app/views/User/login_user.dart';
import 'package:skhickens_app/views/User/profile_settings_user.dart';
import 'package:skhickens_app/views/User/profile_user.dart';
import 'package:skhickens_app/views/User/reward_detail.dart';
import 'package:skhickens_app/views/User/reward_redeem_detail.dart';
import 'package:skhickens_app/views/User/scan_screen.dart';
import 'package:skhickens_app/views/User/signup_user.dart';
import 'package:skhickens_app/views/auth/selection_screen.dart';
import 'package:skhickens_app/views/auth/splash_screen.dart';
import 'package:skhickens_app/views/privacy_policy.dart';
import 'package:skhickens_app/views/terms_conditions.dart';

class AppRoutes {
  static const String splash = '/';
  static const String selection = '/selection';
  static const String addDeal = '/addDeal';
  static const String addReward = '/addReward';
  static const String homeBusinessExtended = '/homeBusinessExtended';
  static const String homeBusiness = '/homeBusiness';
  static const String loginBusiness = '/loginBusiness';
  static const String profileSettingsBusiness = '/profileSettingsBusiness';
  static const String rewardsBusiness = '/rewardsBusiness';
  static const String signupBusiness = '/signupBusiness';
  static const String subscriptionPlan = '/subscriptionPlan';
  static const String businessDetail = '/businessDetail';
  static const String dealDetail = '/dealDetail';
  static const String favouritesScreen = '/favouritesScreen';
  static const String homeUser = '/homeUser';
  static const String locationChangeScreen = '/locationChangeScreen';
  static const String loginUser = '/loginUser';
  static const String profileSettingUser = '/profileSettingsUser';
  static const String profileUser = '/profileUser';
  static const String rewardDetail = '/rewardDetail';
  static const String rewardRedeemDetail = '/rewardRedeemDetail';
  static const String scanScreen = '/scanScreen';
  static const String signupUser = '/signupUser';
  static const String privacyPolicy = '/privacyPolicy';
  static const String termsAndConditions = '/termsAndConditions';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: selection, page: () => SelectionScreen()),
    GetPage(name: addDeal, page: () => AddDeals()),
    GetPage(name: addReward, page: () => AddRewards()),
    GetPage(name: homeBusinessExtended, page: () => HomeBusinessExtended()),
    GetPage(name: homeBusiness, page: () => HomeBusiness()),
    GetPage(name: loginBusiness, page: () => LoginBusiness()),
    GetPage(name: profileSettingsBusiness, page: () => ProfileSettingsBusiness()),
    GetPage(name: rewardsBusiness, page: () => RewardsBusiness()),
    GetPage(name: signupBusiness, page: () => SignupBusiness()),
    GetPage(name: subscriptionPlan, page: () => SubscriptionPlan()),
    GetPage(name: businessDetail, page: () => BusinessDetail()),
    GetPage(name: dealDetail, page: () => DealDetail()),
    GetPage(name: favouritesScreen, page: () => FavouritesScreen()),
    GetPage(name: homeUser, page: () => HomeUser()),
    GetPage(name: locationChangeScreen, page: () => LocationChangeScreen()),
    GetPage(name: loginUser, page: () => LoginUser()),
    GetPage(name: profileSettingUser, page: () => ProfileSettingsUser()),
    GetPage(name: profileUser, page: () => ProfileUser()),
    GetPage(name: rewardDetail, page: () => RewardDetail()),
    GetPage(name: rewardRedeemDetail, page: () => RewardRedeemDetail()),
    GetPage(name: scanScreen, page: () => ScanScreen()),
    GetPage(name: signupUser, page: () => SignupUser()),
    GetPage(name: privacyPolicy, page: () => PrivacyPolicy()),
    GetPage(name: termsAndConditions, page: () => TermsAndConditions()),
  ];
}