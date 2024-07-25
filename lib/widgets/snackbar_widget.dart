import 'package:get/get.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';

snackBar(String title, String body){
                              Get.snackbar(
                                title, body,
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: AppColors.whiteColor,
                                borderColor: AppColors.gradientEndColor,
                                borderWidth: 5,
                                );
}