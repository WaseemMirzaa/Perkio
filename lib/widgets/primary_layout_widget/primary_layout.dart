import 'package:flutter/material.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';


class PrimaryLayoutWidget extends StatelessWidget {
  PrimaryLayoutWidget({super.key, required this.header, required this.body, required this.footer});
  Widget body;
  Widget header;
  Widget footer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          body,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children : [
              header,
              footer
            ],)
        ],
      ),
    );
  }
}