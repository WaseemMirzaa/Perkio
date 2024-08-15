import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // Assuming you're using the sizer package for responsive sizing
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart'; // Import your AppColors
import 'package:skhickens_app/core/utils/constants/text_styles.dart'; // Import your custom text styles

class ProfileListItems extends StatelessWidget {
  final String path;
  final TextEditingController textController;
  final bool enabled;
  final Function()? onTap;

  const ProfileListItems({
    super.key,
    required this.path,
    required this.textController,
    this.enabled = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      maxLines: 1,
      readOnly: enabled ? false : true,
      style: poppinsRegular(fontSize: 14.sp),
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(10.sp),
          child: ImageIcon(
            AssetImage(
            path,),size: 20.sp,
          ),
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
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: enabled ? AppColors.gradientStartColor : AppColors.hintText.withOpacity(0.5) ,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 12.sp),
      ),
    );
  }
}
