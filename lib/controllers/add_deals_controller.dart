import 'package:get/get.dart';

class AddDealsController extends GetxController {
  RxInt counter = 0.obs;

  void increaseCounter() {
    counter++;
  }

  void decreaseCounter(){
    (counter == 0) ? null : counter--;
  }
}