import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
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
    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    phoneFocusNode.dispose();
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
  late FocusNode nameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode phoneFocusNode;

  ///💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 SIGN IN

  Future<void> signIn(String email, String password) async {
    loading.value = true;
    String? result = await authServices.signIn(email, password);
    if (result == null) {
      UserModel? userModel = await userServices.getUserById(FirebaseAuth.instance.currentUser!.uid);
      if (userModel != null) {
        loading.value = false;
        clearTextFields();
        Get.off(() => BottomBarView(isUser: userModel.isUser!));
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


  ///♦Heart
  /// 💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛

  Future<void> logout() async {
    authServices.logOut().then((value) => Get.off(const SplashScreen()));
  }

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 ADD TO FIREBASE

  Future<void> addUserData(String name, String email, String phone, bool isUser) async {
    userServices.addUserData(fullName: name, email: email, phone: phone, isUser: isUser);
  }

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛️ UPDATE USER

  Future<bool> updateUser(Map<String, dynamic> updatedData) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    return await userServices.updateUser(uid, updatedData);
  }

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

  Future<void> setUserInfo(UserModel userModel)async{
    await setValue(SharedPrefKey.uid, userModel.userId);
    await setValue(SharedPrefKey.isUser, userModel.isUser);
    await setValue(SharedPrefKey.userName, userModel.userName);
    await setValue(SharedPrefKey.email, userModel.email);
    await setValue(SharedPrefKey.photo, userModel.image);
  }
}