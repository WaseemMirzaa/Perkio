import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddDealsController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dealNameController = TextEditingController();
    dealPriceController = TextEditingController();
    usesController = TextEditingController();
  }

  @override
  void dispose() {
    print('------------? print dispose');

    // TODO: implement dispose
    super.dispose();
    dealNameController.dispose();
    dealPriceController.dispose();
    usesController.dispose();
  }

  void clearTextFields() {
    dealNameController.clear();
    dealPriceController.clear();
    usesController.clear();
  }

  RxInt counter = 0.obs;
  late TextEditingController dealNameController;
  late TextEditingController dealPriceController;
  late TextEditingController usesController;

  void increaseCounter() {
    counter++;
  }

  void decreaseCounter(){
    (counter == 0) ? null : counter--;
  }
}