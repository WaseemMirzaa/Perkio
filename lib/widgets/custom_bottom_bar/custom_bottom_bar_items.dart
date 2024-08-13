import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';

class CustomBottomBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Function onTap;
  final String path;

  CustomBottomBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onTap(),
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 0),
      // highlightColor: AppColors.whiteColor.withOpacity(0.5),
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(path, scale: 3,),
          const SizedBox(height: 2),
          isSelected ?
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: const LinearGradient(
                colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ) : const SizedBox(height: 6, width: 6,)
        ],
      ),
    );
  }
}
