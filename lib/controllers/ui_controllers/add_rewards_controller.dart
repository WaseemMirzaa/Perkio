import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRewardsController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dealNameController = TextEditingController();
    receiptPriceController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void dispose() {
    print('------------? print dispose');

    // TODO: implement dispose
    super.dispose();
    dealNameController.dispose();
    receiptPriceController.dispose();
    detailsController.dispose();
  }

  void clearTextFields() {
    dealNameController.clear();
    receiptPriceController.clear();
    detailsController.clear();
  }

  late TextEditingController dealNameController;
  late TextEditingController receiptPriceController;
  late TextEditingController detailsController;
}