import 'package:get/get.dart';
import 'package:swipe_app/controllers/notification_controller.dart';
import 'package:swipe_app/controllers/ui_controllers/add_deals_controller.dart';
import 'package:swipe_app/controllers/ui_controllers/add_rewards_controller.dart';
import 'package:swipe_app/controllers/business_controller.dart';
import 'package:swipe_app/controllers/ui_controllers/business_detail_controller.dart';
import 'package:swipe_app/controllers/ui_controllers/favourites_screen_controller.dart';
import 'package:swipe_app/controllers/home_controller.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/services/business_services.dart';
import 'package:swipe_app/services/home_services.dart';
import 'package:swipe_app/services/user_services.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddDealsController(), fenix: true);
    Get.lazyPut(() => AddRewardsController(), fenix: true);
    Get.lazyPut(() => BusinessDetailController(), fenix: true);
    Get.lazyPut(() => FavouritesScreenController(), fenix: true);
    Get.lazyPut(() => UserController(UserServices()), fenix: true);
    Get.lazyPut(() => BusinessController(BusinessServices()), fenix: true);
    Get.lazyPut(() => HomeController(HomeServices()), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
  }
}
