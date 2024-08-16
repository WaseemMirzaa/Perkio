import 'package:flutter/material.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';


class SecondaryLayoutWidget extends StatelessWidget {
  SecondaryLayoutWidget({super.key, required this.header, required this.body});
  Widget body;
  Widget header;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          body,
          header,
            ],
      ),
    );
  }
}