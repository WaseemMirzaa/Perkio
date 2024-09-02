import 'package:get/get.dart';
import 'package:swipe_app/models/notification_model.dart';
import 'package:swipe_app/services/notification_services.dart';

class NotificationController extends GetxController{
  NotificationServices notificationServices;
  NotificationController(this.notificationServices);

  Stream<List<NotificationModel>> getNotifications(){
    return notificationServices.getNotifications();
  }
}