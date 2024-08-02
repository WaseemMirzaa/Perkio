import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddDealsController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dealNameController = TextEditingController();
    companyNameController = TextEditingController();
    addressController = TextEditingController();
    usesController = TextEditingController();
  }

  @override
  void dispose() {
    print('------------? print dispose');

    // TODO: implement dispose
    super.dispose();
    dealNameController.dispose();
    companyNameController.dispose();
    addressController.dispose();
    usesController.dispose();
  }

  void clearTextFields() {
    dealNameController.clear();
    companyNameController.clear();
    addressController.clear();
    usesController.clear();
  }

  RxInt counter = 0.obs;
  late TextEditingController dealNameController;
  late TextEditingController companyNameController;
  late TextEditingController addressController;
  late TextEditingController usesController;

  void increaseCounter() {
    counter++;
  }

  void decreaseCounter(){
    (counter == 0) ? null : counter--;
  }
}