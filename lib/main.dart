import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
            initialRoute: AppRoutes.splash,
            initialBinding: MyBinding(),
            getPages: AppRoutes.routes,
          ),
        );
      }
    );
  }
}
