import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/billing_service.dart';
import 'package:swipe_app/controllers/rewards_controller.dart';
import 'package:swipe_app/controllers/subscription_controller.dart';
import 'package:swipe_app/firebase_options.dart';
import 'package:swipe_app/bindings/bindings.dart';
import 'package:swipe_app/services/fcm_manager.dart';
import 'package:swipe_app/services/push_notification_service.dart';
import 'package:swipe_app/services/revenue_cat_service.dart';
import 'package:swipe_app/views/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FCMManager.initialize();
  await RevenueCatService.init();

  // Initialize Push Notification Services
  PushNotificationServices pushNotificationServices =
      PushNotificationServices();
  await pushNotificationServices.init();

  // Set the status bar appearance globally
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Transparent or any color
    statusBarIconBrightness:
        Brightness.dark, // Icons: dark (for light backgrounds)
    statusBarBrightness: Brightness.light, // For iOS status bar
  ));

  // UserServices userServices = UserServices();
  // String? userId = await userServices.getCurrentUserIdFromPreferences();
  // bool? isUser = await userServices.getIsUserFromPreferences();
  // Widget home = userId != null
  //   ? (isUser == true ? const BottomBarView(isUser: true) : const BottomBarView(isUser: false))
  //   : const SplashScreen();
  Stripe.publishableKey =
      'pk_test_51PQ2iD00So438QdeQFWS7Bz2EyESwD51vEyhC0QFY2RqwA7rqp1xktxV8FHGbzm1XppVO4bWy9vStrGOS3BV76Q900auavqmqT';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  BillingService().initStore();

  Get.put(SubscriptionController());

  Get.put(RewardController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GestureDetector(
        onTap: () {
          try {
            FocusManager.instance.primaryFocus?.unfocus();
          } catch (e, stacktrace) {
            if (kDebugMode) {
              print('Error in onTap: $e');
              print('Stacktrace: $stacktrace');
            }
          }
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Swipe',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          // home: HomeSubscriptionScreen(),
          initialBinding: MyBinding(),

          // home: const VendorSubscriptionUI(),
        ),
      );
    });
  }
}
