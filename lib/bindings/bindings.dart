import 'package:get/get.dart';
import 'package:skhickens_app/controllers/add_deals_controller.dart';
import 'package:skhickens_app/controllers/business_detail_controller.dart';
import 'package:skhickens_app/controllers/favourites_screen_controller.dart';
import 'package:skhickens_app/controllers/user_controller.dart';
import 'package:skhickens_app/services/user_services.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddDealsController(), fenix: true);
    Get.lazyPut(() => BusinessDetailController(), fenix: true);
    Get.lazyPut(() => FavouritesScreenController(), fenix: true);
    Get.lazyPut(() => UserController(UserServices()), fenix: true);
  }
}
