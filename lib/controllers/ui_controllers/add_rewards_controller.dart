import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRewardsController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dealNameController = TextEditingController();
    pointsToRedeemController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void dispose() {
    print('------------? print dispose');

    // TODO: implement dispose
    super.dispose();
    dealNameController.dispose();
    pointsToRedeemController.dispose();
    detailsController.dispose();
  }

  void clearTextFields() {
    dealNameController.clear();
    pointsToRedeemController.clear();
    detailsController.clear();
  }

  late TextEditingController dealNameController;
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