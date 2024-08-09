import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/controllers/home_controller.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/modals/reward_modal.dart';
import 'package:skhickens_app/modals/user_modal.dart';
import 'package:skhickens_app/services/auth_services.dart';
import 'package:skhickens_app/services/home_services.dart';
import 'package:skhickens_app/services/user_services.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/views/splash_screen.dart';
import 'package:skhickens_app/widgets/activation_dialog.dart';

class UserController extends GetxController {
  UserServices userServices;
  UserController(this.userServices);

  HomeController homeController = Get.put(HomeController(HomeServices()));

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

  Future<void> signIn(String email, String password) async {
    loading.value = true;
    String? result = await authServices.signIn(email, password);
    if (result == null) {
      UserModel? userModel = await userServices.getUserById(FirebaseAuth.instance.currentUser!.uid);
      if (userModel != null) {
        setUserInfo(userModel);
        loading.value = false;
        clearTextFields();
        Get.off(() => BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false ));
      } else {
        loading.value = false;
        Get.snackbar('Error', 'Failed to fetch user data.', snackPosition: SnackPosition.TOP);
      }
    } else {
      loading.value = false;
      Get.snackbar('Error', result, snackPosition: SnackPosition.TOP);
    }
  }

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 SIGN UP
  Future<void> signUp(UserModel userModel) async {
    loading.value = true;
    String? result = await authServices.signUp(userModel);
    if (result != null) {
      userModel.userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if(getStringAsync(SharedPrefKey.role) == SharedPrefKey.business){
        final logoLink = await homeController.uploadImageToFirebaseWithCustomPath(userModel.logo!, 'business_logo/$result');
        final image = await homeController.uploadImageToFirebaseOnID(userModel.image!, result);
        if(logoLink != null && image != null){
          userModel.logo = logoLink;
          userModel.image = image;
          await setValue(SharedPrefKey.photo, image);
        }
      }
      await addUserData(userModel);
      loading.value = false;
      clearTextFields();
      getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? Get.off(() => BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false)) : showActivationDialog();
    } else {
      loading.value = false;
      Get.snackbar('Error', 'Account not created', snackPosition: SnackPosition.TOP);
    }
  }


  ///♦Heart
  /// ♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️

  Future<void> logout() async {
    authServices.logOut().then((value) => Get.off(const SplashScreen()));
  }

  //💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛 ADD TO FIREBASE

  Future<bool> addUserData(UserModel userModel) async {
    return await userServices.addUserData(userModel);
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

  //♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️Heart
  //
  // 💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚 UNLIKE DEAL

  Future<void> unLikeDeal(String dealId) async {
    userServices.unLikeDeal(dealId);
  }

  Future<void> setUserInfo(UserModel userModel)async{
    await setValue(SharedPrefKey.uid, userModel.userId);
    await setValue(SharedPrefKey.role, userModel.role);
    await setValue(SharedPrefKey.userName, userModel.userName);
    await setValue(SharedPrefKey.email, userModel.email);
    await setValue(SharedPrefKey.photo, userModel.image);
    await setValue(SharedPrefKey.address, userModel.address);
  }
}