import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/firebase_options.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/bindings/bindings.dart';
import 'package:skhickens_app/services/user_services.dart';
import 'package:skhickens_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:skhickens_app/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  UserServices userServices = UserServices();
  String? userId = await userServices.getCurrentUserIdFromPreferences();
  bool? isUser = await userServices.getIsUserFromPreferences();
  Widget home = userId != null
    ? (isUser == true ? const BottomBarView(isUser: true) : const BottomBarView(isUser: false))
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
        return GestureDetector(
          onTap: (){
            try {
              FocusManager.instance.primaryFocus?.unfocus();
            } catch (e, stacktrace) {
              print('Error in onTap: $e');
              print('Stacktrace: $stacktrace');
              // FirebaseCrashlytics.instance.recordError(e, stacktrace);
            }
          },
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: home,
            // initialRoute: AppRoutes.splash,
            initialBinding: MyBinding(),
            getPages: AppRoutes.routes,
          ),
        );
      }
    );
  }
}
