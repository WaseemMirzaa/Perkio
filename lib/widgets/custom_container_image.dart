import 'package:flutter/material.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';

class CustomImageContainer extends StatelessWidget {
  const CustomImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))          ),
          ),
          Image.asset(AppAssets.splashImg),
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))          ),
          ),
          Positioned(
            bottom: 3,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100))          ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              height: 50,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100))          ),
            ),
          ),
          
        ],
      ),
    );
  }
}
