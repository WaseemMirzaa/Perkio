import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // Assuming you're using the sizer package for responsive sizing
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart'; // Import your AppColors
import 'package:skhickens_app/core/utils/constants/text_styles.dart'; // Import your custom text styles

class ProfileListItems extends StatelessWidget {
  final String path;
  final TextEditingController textController;
  final bool enabled;

  const ProfileListItems({
    super.key,
    required this.path,
    required this.textController,
    this.enabled = false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      maxLines: 1,
      enabled: enabled,
      style: poppinsRegular(fontSize: 14.sp),
      decoration: InputDecoration(
        prefixIcon: Image.asset(
          path,
          scale: 3,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.hintText.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.hintText.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.gradientStartColor,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 12.sp),
      ),
    );
  }
}
