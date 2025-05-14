import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/app_images.dart';
import 'package:swipe_app/widgets/customize_slide_btn_comp.dart';
import 'package:slide_to_act/slide_to_act.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onSwipe;
  final String text;
  final bool isGradient;
  final double fontSize;
  ButtonWidget(
      {super.key,
      required this.onSwipe,
       this.fontSize = 14,
      required this.text,
      this.isGradient = true});
  final GlobalKey<SlideActionState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return CustomSlideActionButton(
      key: _key,
      height: 9.h,
      onSubmit: () {
        Future.delayed(
          const Duration(seconds: 1),
          () => _key.currentState?.reset(),
        );
        onSwipe();
        return null;
      },
      text: text,
      sliderButtonIcon: Container(
          height: 42.sp,
          width: 42.sp,
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   color: isGradient ? AppColors.whiteColor : null,
          //   gradient: isGradient
          //       ? null
          //       : const LinearGradient(
          //           colors: [
          //             AppColors.gradientStartColor,
          //             AppColors.gradientEndColor
          //           ],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          // ),
          decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor, 
        ),
      
          child: Image.asset(
            AppImages.logo,
            scale: 2.5,
          )),
      sliderButtonIconPadding: 0,
      textStyle: poppinsBold(
          fontSize: fontSize,
          color: isGradient ? AppColors.whiteColor : AppColors.blackColor),
      outerColor: Colors.grey[200],
      innerColor: Colors.black,
      gradient: isGradient
          ? const LinearGradient(
              colors: [
                AppColors.gradientStartColor,
                AppColors.gradientEndColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
    );
  }
}
