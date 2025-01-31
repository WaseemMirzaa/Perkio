import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/auth/login_view.dart';
import 'package:swipe_app/widgets/selection_tile.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientStartColor,
              AppColors.gradientEndColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Spacer(), // Pushes content below towards the center.
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Center(
                  //   child: Text(
                  //     TempLanguage.lblSwipe,
                  //     style: altoysFont(
                  //       fontSize: 45,
                  //       color: AppColors.whiteColor,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  Image.asset(
                    'assets/images/logo.png', // Replace with the correct path to your logo
                    height: 100, // Adjust size as needed
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${TempLanguage.txtSwipeSS}, ${TempLanguage.txtSScanS}, and ${TempLanguage.txtSSSave}.",
                    style: poppinsRegular(
                      color: AppColors.whiteColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(), // Balances space between top content and tiles.
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await setValue(SharedPrefKey.role, SharedPrefKey.user);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(isUser: true),
                        ),
                      );
                    },
                    child: const SelectionTile(
                      imgPath: AppAssets.userSel,
                      text: 'I\'m a user',
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      await setValue(
                          SharedPrefKey.role, SharedPrefKey.business);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(isUser: false),
                        ),
                      );
                    },
                    child: const SelectionTile(
                      imgPath: AppAssets.businessSel,
                      text: 'I\'m a business',
                    ),
                  ),
                ],
              ),
              const Spacer(), // Ensures tiles stay near the center.
            ],
          ),
        ),
      ),
    );
  }
}
