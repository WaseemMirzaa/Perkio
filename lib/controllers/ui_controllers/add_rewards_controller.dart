import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRewardsController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    rewardNameController = TextEditingController();
    pointsToRedeemController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void dispose() {
    print('------------? print dispose');

    // TODO: implement dispose
    super.dispose();
    rewardNameController.dispose();
    pointsToRedeemController.dispose();
    detailsController.dispose();
  }

  void clearTextFields() {
    rewardNameController.clear();
    pointsToRedeemController.clear();
    detailsController.clear();
  }

  late TextEditingController rewardNameController;
  late TextEditingController pointsToRedeemController;
  late TextEditingController detailsController;
  RxInt counter = 0.obs;

  void increaseCounter() {
    counter++;
  }

  void decreaseCounter(){
    (counter == 0) ? null : counter--;
  }
}