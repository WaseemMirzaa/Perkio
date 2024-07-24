import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/firebase_options.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/bindings/bindings.dart';
import 'package:skhickens_app/services/user_services.dart';
import 'package:skhickens_app/views/auth/splash_screen.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  UserServices userServices = UserServices();
  String? userId = await userServices.getCurrentUserIdFromPreferences();
  bool? isUser = await userServices.getIsUserFromPreferences();
  Widget home = userId != null 
    ? (isUser == true ? BottomBarView(isUser: true) : BottomBarView(isUser: false)) 
    : SplashScreen();

  runApp(MyApp(home));
}

class MyApp extends StatelessWidget {
  final Widget home;
  MyApp(this.home);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(

            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: home,
          initialBinding: MyBinding(),
          getPages: AppRoutes.routes,
        );
      }
    );
  }
}
