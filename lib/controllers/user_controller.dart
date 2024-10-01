import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/networking/stripe.dart';
import 'package:swipe_app/services/auth_services.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/services/reward_service.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/views/splash_screen/splash_screen.dart';

class UserController extends GetxController {
  UserServices userServices;
  UserController(this.userServices);

  HomeController homeController = Get.put(HomeController(HomeServices()));
  var isSearching = false.obs;

  final RewardService _rewardService = RewardService();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    phoneController = TextEditingController();

    // Fetch favorite deals on controller initialization
    fetchAndCacheFavouriteDeals();
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ GET FAVOURITE DEALS

  Future<List<DealModel>> getFavouriteDeals() async {
    var res = await userServices
        .getFavouriteDeals(authServices.auth.currentUser!.uid);
    return res;
  }

  // Cache for favorite statuses
  var favoriteCache = <String, bool>{}.obs;

//♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ LIKE DEAL
  Future<void> likeDeal(String dealId) async {
    await userServices.likeDeal(dealId);
    favoriteCache[dealId] = true; // Update cache
  }

  //💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚 UNLIKE DEAL
  Future<void> unLikeDeal(String dealId) async {
    await userServices.unLikeDeal(dealId);
    favoriteCache[dealId] = false; // Update cache
  }

  // Fetch and cache favorite status
  Future<bool> isDealFavorite(String dealId) async {
    if (favoriteCache.containsKey(dealId)) {
      return favoriteCache[dealId]!;
    }

    bool isFavorite = await userServices.isDealFavorite(dealId);
    favoriteCache[dealId] = isFavorite; // Update cache
    return isFavorite;
  }

  /// Fetch and cache all favorite deals on initialization
  Future<void> fetchAndCacheFavouriteDeals() async {
    List<DealModel> favouriteDeals = await getFavouriteDeals();
    for (var deal in favouriteDeals) {
      favoriteCache[deal.dealId!] = true; // Cache the favorite status
    }
    // Notify the UI that favorite status has changed
    favoriteCache.refresh(); // This will notify observers (UI) to update
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    userNameController.dispose();
  }

  void clearTextFields() {
    emailController.clear();
    passwordController.clear();
    userNameController.clear();
    phoneController.clear();
  }

  AuthServices authServices = AuthServices();
  Rx<UserModel> userModel = UserModel().obs;
  RxString userId = ''.obs;
  RxString emailErrorText = "".obs;
  RxString passErrorText = "".obs;
  RxString userNameErrorText = "".obs;
  RxString phoneErrorText = "".obs;
  RxBool loading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxList<UserModel> list = <UserModel>[].obs;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController userNameController;

  ///💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 SIGN IN

  Future<bool> signIn(String email, String password) async {
    try {
      loading.value = true;
      String? result = await authServices.signIn(email, password);
      if (result == null) {
        UserModel? userModel = await userServices
            .getUserById(FirebaseAuth.instance.currentUser!.uid);
        if (userModel != null) {
          await setUserInfo(userModel);
          loading.value = false;
          clearTextFields();
        } else {
          loading.value = false;
          // Get.snackbar('Error', 'Failed to fetch user data.', snackPosition: SnackPosition.TOP);
          return false;
        }
      } else {
        loading.value = false;
        // Get.snackbar('Error', 'Incorrect email and password', snackPosition: SnackPosition.TOP);
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  //
  Stream<UserModel?> getUserByStream(String userId) {
    return userServices.getUserByStream(userId);
  }

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 SIGN UP
  Future<void> signUp(UserModel userModel, Function onError) async {
    loading.value = true;
    try {
      String? result = await authServices.signUp(userModel);

      if (result != null) {
        userModel.userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        final stripeCustomerId =
            await StripePayment.createStripeCustomer(email: userModel.email!);
        print("STRIPE: $stripeCustomerId");

        if (!stripeCustomerId.isEmptyOrNull) {
          userModel.stripeCustomerId = stripeCustomerId;
        }

        if (getStringAsync(SharedPrefKey.role) == SharedPrefKey.business) {
          final logoLink =
              await homeController.uploadImageToFirebaseWithCustomPath(
                  userModel.logo!, 'business_logo/$result');
          final image = await homeController.uploadImageToFirebaseOnID(
              userModel.image!, result);

          if (logoLink != null && image != null) {
            userModel.logo = logoLink;
            userModel.image = image;
            await setValue(SharedPrefKey.photo, image);
          }
        }

        await addUserData(userModel)
            .then((value) async => await setUserInfo(userModel));

        loading.value = false;
        clearTextFields();

        // Navigate based on user role
        if (getStringAsync(SharedPrefKey.role) == SharedPrefKey.user) {
          Get.off(() => LocationService(
              child: BottomBarView(
                  isUser: getStringAsync(SharedPrefKey.role) ==
                      SharedPrefKey.user)));
        }
      } else {
        loading.value = false;
        onError(); // Call the error callback
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      // Display the exact Firebase error message
      Get.snackbar('Firebase Error', e.message ?? 'Account creation failed.',
          snackPosition: SnackPosition.TOP);
      loading.value = false;
      log('--------IN FIREBASE  EXCEPTIONNNNNNNNNNNN======');

      // Log the error for debugging
      log("FirebaseAuthException: ${e.message}");

      // Display the exact Firebase error message
      Get.snackbar('Firebase Error', e.message ?? 'Account creation failed.',
          snackPosition: SnackPosition.TOP);

      onError(); // Call the error callback
    } catch (e) {
      Get.back();
      // Catch other unknown errors
      Get.snackbar('Error', 'An unknown error occurred',
          snackPosition: SnackPosition.TOP);

      loading.value = false;

      // Log the error for debugging
      log("Unknown error: $e");

      onError(); // Call the error callback
    }
  }

  Future<bool> addUserData(UserModel userModel) async {
    return await userServices.addUserData(userModel);
  }

  ///♦Heart
  /// ♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️

  Future<void> logout() async {
    authServices.logOut().then((value) => Get.off(const SplashScreen()));
  }

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 ADD TO FIREBASE

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 GET USER

  Future<UserModel?> getUser(String uid) async {
    final userModel = await userServices.getUserById(uid);
    await setUserInfo(userModel!);
    return userModel;
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ GET All DEALS

  Future<List<DealModel>> getDeals() async {
    var res = await userServices.getDeals();
    return res;
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ GET All REWARDS

  Future<List<RewardModel>> getRewards() async {
    var res = await userServices.getRewards();
    return res;
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ GET All REWARDS

  Future<List<RewardModel>> getRewardForCurrentUser() async {
    var res = await userServices.getRewardsForCurrentUser();
    return res;
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ GET FAVOURITE DEALS

  Future<List<DealModel>> getDealsUsedByCurrentUser() async {
    var res = await userServices.getDealsUsedByCurrentUser();
    return res;
  }

  Future<void> setUserInfo(UserModel userModel) async {
    await setValue(SharedPrefKey.uid, userModel.userId);
    await setValue(SharedPrefKey.role, userModel.role);
    await setValue(SharedPrefKey.userName, userModel.userName);
    await setValue(SharedPrefKey.email, userModel.email);

    // Handle the image null case
    await setValue(SharedPrefKey.photo, userModel.image ?? "");
    await setValue(SharedPrefKey.address, userModel.address ?? "");

    // Handle potential null values for latLong
    if (userModel.latLong != null) {
      await setValue(SharedPrefKey.latitude, userModel.latLong!.latitude);
      await setValue(SharedPrefKey.longitude, userModel.latLong!.longitude);
    } else {
      // Provide default values if latLong is null
      await setValue(SharedPrefKey.latitude, 0.0);
      await setValue(SharedPrefKey.longitude, 0.0);
    }

    await setValue(UserKey.BALANCE, userModel.balance ?? 0);
    await setValue(
        UserKey.ISPROMOTIONSTART, userModel.isPromotionStart ?? false);
    await setValue(UserKey.ISVERIFIED, userModel.isVerified ?? false);
    await setValue(UserKey.STRIPECUSTOMERID, userModel.stripeCustomerId ?? "");
  }

  Future<List<RewardModel>> fetchFavouriteRewards() async {
    List<RewardModel> favouriteRewards =
        await _rewardService.getFavouriteRewards();
    // Handle the fetched rewards

    return favouriteRewards;
  }
}
