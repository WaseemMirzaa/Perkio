import 'package:get/get.dart' as X;

showSnackBar(String title, String body){
  print('Snack bar called');
  X.Get.snackbar(
    title, body,
    snackPosition: X.SnackPosition.TOP,
    // backgroundColor: AppColors.whiteColor,
    // borderColor: AppColors.gradientEndColor,
    // borderWidth: 5,
  );
}