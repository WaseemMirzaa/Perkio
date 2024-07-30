import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/modals/reward_modal.dart';
import 'package:skhickens_app/modals/user_modal.dart';
import 'package:skhickens_app/services/auth_services.dart';
import 'package:skhickens_app/services/user_services.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/views/splash_screen.dart';
import 'package:skhickens_app/widgets/activation_dialog.dart';

class UserController extends GetxController {
  UserServices userServices;
  // final RxString userId = GlobalVariable.userid.obs;
  UserController(this.userServices);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    print('------------? print dispose');

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
  UserModel userProfile = UserModel();
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

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ SIGN IN
  Future<void> signIn(String email, String password) async {
    loading.value = true;
    String? result = await authServices.signIn(email, password);
    if (result == null) {
      bool? isUser = await userServices.getIsUserFromPreferences();
      if (isUser != null) {
        loading.value = false;
        clearTextFields();
        isUser ? Get.off(() => const BottomBarView(isUser: true)) : Get.off(() => const BottomBarView(isUser: false));
      } else {
        loading.value = false;
        Get.snackbar('Error', 'Failed to fetch user data.', snackPosition: SnackPosition.TOP);
      }
    } else {
      loading.value = false;
      Get.snackbar('Error', result, snackPosition: SnackPosition.TOP);
    }
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ SIGN UP
  Future<void> signUp(String email, String password, String username, String phone, bool isRole) async {
    loading.value = true;
    String? result = await authServices.signUp(email, password, username, phone);
    if (result == null) {
      await addUserData(username, email, phone, true);
      loading.value = false;
      clearTextFields();
      isRole ? Get.off(() => BottomBarView(isUser: isRole)) : showActivationDialog();

    } else {
      loading.value = false;
      Get.snackbar('Error', result, snackPosition: SnackPosition.TOP);
    }
  }
  //
  // //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ SIGN IN BUSINESS
  // Future<void> signInBusiness(String email, String password) async {
  //   loading.value = true;
  //   String? result = await authServices.signIn(email, password);
  //   if (result == null) {
  //     UserModel userModel = await getUser();
  //     if (userModel.userId != '') {
  //       bool isUser = userModel.isUser ?? false;
  //       if (!isUser) {
  //         loading.value = false;
  //         clearTextFields();
  //         Get.off(() => const BottomBarView(isUser: false));
  //       } else {
  //         loading.value = false;
  //         Get.snackbar('Error', 'You are not authorized as a business.', snackPosition: SnackPosition.TOP);
  //       }
  //     } else {
  //       loading.value = false;
  //       Get.snackbar('Error', 'User document not found.', snackPosition: SnackPosition.TOP);
  //     }
  //   } else {
  //     loading.value = false;
  //     Get.snackbar('Error', result, snackPosition: SnackPosition.TOP);
  //   }
  // }


  // //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ SIGN UP BUSINESS
  // Future<void> signUpBusiness(String email, String password, String username, String phone) async {
  //   loading.value = true;
  //   String? result = await authServices.signUp(email, password, username, phone);
  //   if (result == null) {
  //     await addUserData(username, email, phone, false);
  //     loading.value = false;
  //     clearTextFields();
  //     showActivationDialog();
  //   } else {
  //     loading.value = false;
  //     Get.snackbar('Error', result, snackPosition: SnackPosition.TOP);
  //   }
  // }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ LOGOUT
  Future<void> logout() async {
    authServices.logOut();
    Get.off(const SplashScreen());
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ ADD TO FIREBASE
  Future<void> addUserData(String name, String email, String phone, bool isUser) async {
    userServices.addUserData(fullName: name, email: email, phone: phone, isUser: isUser);
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ UPDATE USER
  Future<bool> updateUser(Map<String, dynamic> updatedData) async {
    // Reference to the user document
    var uid = FirebaseAuth.instance.currentUser!.uid;
    return await userServices.updateUser(uid, updatedData);
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ GET USER
  Future<UserModel> getUser() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    return (await userServices.getUserById(uid))!;
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

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ GET FAVOURITE DEALS
  Future<List<DealModel>> getFavouriteDeals() async {
    var res = await userServices.getFavouriteDeals(authServices.auth.currentUser!.uid);
    return res;
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ LIKE DEAL
  Future<void> likeDeal(String dealId) async {
    userServices.likeDeal(dealId);
  }

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️ UNLIKE DEAL
  Future<void> unLikeDeal(String dealId) async {
    userServices.unLikeDeal(dealId);
  }
}