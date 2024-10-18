import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/models/business_details_model.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/networking/stripe.dart';
import 'package:swipe_app/services/auth_services.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/services/reward_service.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/place_picker/apis.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/views/splash_screen/splash_screen.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  UserServices userServices;
  UserController(this.userServices);

  HomeController homeController = Get.put(HomeController(HomeServices()));
  var isSearching = false.obs;

  final RewardService _rewardService = RewardService();

  String? currentUseruid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController = TextEditingController();
    resetEmailController = TextEditingController();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    phoneController = TextEditingController();

    // Fetch favorite deals on controller initialization
    if (currentUseruid != null) {
      fetchAndCacheFavouriteDeals();
    }
  }

  // Method to reset password by sending an email
  Future<bool> sendPasswordReset(String email, bool isUser) async {
    loading.value = true;

    // Validate that email is not empty and in correct format
    if (email.isEmpty) {
      loading.value = false;
      Get.snackbar('Error', 'Email is required');
      resetEmailController.clear();
      return false;
    } else if (!isValidEmail(email)) {
      loading.value = false;
      Get.snackbar('Error', 'Please enter a valid email address');
      return false;
    }

    try {
      // Call UserService to check if email exists and send password reset email
      bool isSuccess =
          await userServices.resetPasswordIfEmailExists(email, isUser);

      if (isSuccess) {
        loading.value = false;
        Get.snackbar('Success', 'Password reset email sent');
        resetEmailController.clear();

        return true;
      } else {
        loading.value = false;
        Get.snackbar('Error', 'No user found with this email');
        return false;
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Error', 'Something went wrong. Please try again.');
      return false;
    }
  }

  bool isValidEmail(String email) {
    // Corrected regular expression to validate email
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
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
    resetEmailController.dispose();
  }

  void clearTextFields() {
    emailController.clear();
    passwordController.clear();
    userProfile.value = null;
    userNameController.clear();
    phoneController.clear();
    resetEmailController.clear();
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
  late TextEditingController resetEmailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController userNameController;

  ///💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 SIGN IN

  Future<bool> signIn(String email, String password, bool isUser) async {
    try {
      loading.value = true;
      String? result = await authServices.signIn(email, password, isUser);
      if (result == null) {
        UserModel? userModel = await userServices
            .getUserById(FirebaseAuth.instance.currentUser!.uid);
        if (userModel != null) {
          print('------------💥💥💥💥💥 I AM WORKING');
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

  Future<bool> signUp(
      UserModel userModel, Function(String? error) onError, bool isBusiness,
      [String? placeID]) async {
    loading.value = true;

    try {
      BusniessDetailsModel? businessDetails;

      // Check if user is a business and validate the PlaceID
      if (isBusiness) {
        if (placeID == null || placeID.isEmpty) {
          loading.value = false;
          Get.snackbar('Error', 'Invalid Place ID',
              snackPosition: SnackPosition.TOP);
          onError('Invalid Place ID');
          return false;
        }

        // Fetch business details from API
        businessDetails = await fetchBusinessDetails(placeID);

        // Check if the API call returned INVALID_REQUEST or other errors
        if (businessDetails == null ||
            businessDetails.result == null ||
            businessDetails.status != "OK") {
          loading.value = false;
          Get.snackbar(
              'Error', 'Business details not found or invalid Place ID',
              snackPosition: SnackPosition.TOP);
          onError('Business details not found or invalid Place ID');
          return false;
        }
      }

      // Proceed with sign-up
      String? result = await authServices.signUp(userModel);
      if (result != null) {
        userModel.userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        final stripeCustomerId =
            await StripePayment.createStripeCustomer(email: userModel.email!);
        print("STRIPE: $stripeCustomerId");

        if (!stripeCustomerId.isEmptyOrNull) {
          userModel.stripeCustomerId = stripeCustomerId;
        }

        if (isBusiness) {
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

          // Create a subcollection for business details in Firestore
          await createBusinessDetailsSubcollection(result, businessDetails);
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

        return true; // Sign-up successful, return true
      } else {
        loading.value = false;
        onError('Sign-up failed');
        return false; // Sign-up failed, return false
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      // Get.snackbar('Firebase Error', e.message ?? 'Account creation failed.',
      //     snackPosition: SnackPosition.TOP);
      loading.value = false;
      log("FirebaseAuthException: ${e.message}");

      onError(e.message); // Pass the Firebase exception message to onError
      return false; // Firebase error, return false
    } catch (e) {
      Get.back();
      // Get.snackbar('Error', 'An unknown error occurred',
      //     snackPosition: SnackPosition.TOP);
      loading.value = false;
      log("Unknown error: $e");

      onError(
          'An unknown error occurred'); // Pass a generic error message to onError
      return false; // Unknown error, return false
    }
  }

// Function to create the business details subcollection
  Future<void> createBusinessDetailsSubcollection(
      String userId, BusniessDetailsModel? businessDetails) async {
    if (businessDetails == null) {
      print("No business details to save.");
      return;
    }

    try {
      // Create a new document ID for the business details
      String businessDetailId = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('business_details')
          .doc()
          .id;

      // Prepare the data to store in Firestore
      Map<String, dynamic> businessData = {
        'business_detail_firebase_id': businessDetailId,
        ...businessDetails
            .toMap(), // Assuming you have a toMap method in your BusniessDetailsModel
      };

      // Save the business details in the Firestore subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('business_details')
          .doc(businessDetailId)
          .set(businessData);
    } catch (e) {
      print("Error creating business details subcollection: $e");
    }
  }

  Future<BusniessDetailsModel?> fetchBusinessDetails(String placeID) async {
    try {
      // Make the API request

      final apiUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=${Apis.apiKey}";
      final response = await http.get(Uri.parse(apiUrl));

      // Check if the response status is OK
      if (response.statusCode == 200) {
        print("API call successful.");

        // Parse the response body
        final jsonResponse = json.decode(response.body);
        print("Response JSON: $jsonResponse");

        // Create the BusinessDetailsModel from the response
        BusniessDetailsModel businessDetails = BusniessDetailsModel(
          htmlAttributions: jsonResponse['html_attributions'],
          result: jsonResponse['result'] != null
              ? Result(
                  name: jsonResponse['result']['name'],
                  rating: jsonResponse['result']['rating'],
                  reviews: (jsonResponse['result']['reviews'] as List)
                      .map((reviewJson) => Review(
                            authorName: reviewJson['author_name'],
                            authorUrl: reviewJson['author_url'],
                            language: reviewJson['language'],
                            originalLanguage: reviewJson['original_language'],
                            profilePhotoUrl: reviewJson['profile_photo_url'],
                            rating: reviewJson['rating'],
                            relativeTimeDescription:
                                reviewJson['relative_time_description'],
                            text: reviewJson['text'],
                            time: reviewJson['time'],
                            translated: reviewJson['translated'],
                          ))
                      .toList())
              : null,
          status: jsonResponse['status'],
        );

        return businessDetails;
      } else {
        // Handle non-200 responses
        print("API call failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred while fetching business details: $e");
      return null;
    }
  }

  Future<bool> addUserData(UserModel userModel) async {
    return await userServices.addUserData(userModel);
  }

  ///♦Heart
  /// ♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️

  Future<void> logout() async {
    authServices.logOut().then((value) => Get.off(() => const SplashScreen()));
  }

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 ADD TO FIREBASE

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 GET USER

  Future<UserModel?> getUser(String uid) async {
    final userModel = await userServices.getUserById(uid);
    await setUserInfo(userModel!);
    return userModel;
  }

  Stream<UserModel?> gettingUser(String uid) {
    return userServices.gettingUserById(uid).asyncMap((userModel) async {
      if (userModel != null) {
        await setUserInfo(userModel); // Perform any additional logic here
      }
      return userModel;
    });
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ GET All DEALS

  Stream<List<DealModel>> getDeals() {
    return userServices.getDeals();
  }

  Future<void> incrementDealViews(String dealId) async {
    await userServices.updateDealViews(dealId);
  }

  Future<void> incrementDealLikes(String dealId) async {
    await userServices.updateDealLikes(dealId);
  }

  Future<void> decreaseDealLikes(String dealId) async {
    await userServices.updateDealUnLikes(dealId);
  }

  // This method will be called on a button click or other event
  Future<void> handleBusinessBalanceUpdate(String businessId) async {
    if (businessId.isNotEmpty) {
      try {
        print(
            'Initiating balance check and update for businessId: $businessId');
        await userServices.checkAndUpdateBalance(businessId);
        print('Balance check and update process completed');
      } catch (e) {
        print('Error occurred: $e');
        // Show error to the user
      }
    } else {
      print('BusinessId is empty');
    }
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

  //updating the user details
  Rx<UserModel?> userProfile = Rx<UserModel?>(null);

  //UPDATING BUSINESS LOCATION, THEIR REWARDS AND DEALS
  // Method to update both Rewards and Deals collections in a batch

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateBusinessLocation(String newRewardAddress,
      String newDealAddress, GeoPoint newLatLong) async {
    try {
      // Step 1: Get the current user UID
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("User is not logged in");
      }

      String uid = currentUser.uid;
      print("Current User UID: $uid");

      // Step 2: Initialize Firestore batch
      WriteBatch batch = _firestore.batch();

      // Step 3: Get all Rewards where businessId matches
      QuerySnapshot rewardsSnapshot = await _firestore
          .collection('reward')
          .where('businessId', isEqualTo: uid)
          .get();

      // Step 4: Loop through all Rewards documents and update fields
      for (var doc in rewardsSnapshot.docs) {
        DocumentReference rewardRef = doc.reference;
        batch.update(rewardRef, {
          'rewardAddress': newRewardAddress,
          'latLong': newLatLong,
        });
        print("Reward Updated for Doc ID: ${doc.id}");
      }

      // Step 5: Get all Deals where businessId matches
      QuerySnapshot dealsSnapshot = await _firestore
          .collection('deals')
          .where('businessId', isEqualTo: uid)
          .get();

      // Step 6: Loop through all Deals documents and update fields
      for (var doc in dealsSnapshot.docs) {
        DocumentReference dealRef = doc.reference;
        batch.update(dealRef, {
          'location': newDealAddress,
          'latLong': newLatLong,
        });
        print("Deal Updated for Doc ID: ${doc.id}");
      }

      // Step 7: Commit the batch
      await batch.commit();
      print("Batch update successful");
    } catch (e) {
      // Handle errors gracefully
      print("Error updating business location: $e");
      Get.snackbar("Error", "Failed to update business location: $e");
    }
  }
}
