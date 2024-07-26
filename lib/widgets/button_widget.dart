import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/customize_slide_btn_comp.dart';
import 'package:slide_to_act/slide_to_act.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onSwipe;
  final String text;
  final bool isGradient;
  ButtonWidget({super.key, required this.onSwipe, required this.text,this.isGradient = true});
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
      },
      text: text,
      sliderButtonIcon: Container(
          height: 42.sp,
          width: 42.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isGradient ? AppColors.whiteColor : null,
            gradient: isGradient ? null : const LinearGradient(
              colors: [Colors.red, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Image.asset(AppAssets.swipeImg,scale: 2.5,)
      ),
      sliderButtonIconPadding: 0,
      textStyle: poppinsBold(fontSize: 14, color: isGradient ? AppColors.whiteColor : AppColors.blackColor),
      outerColor:  Colors.grey[200],
      innerColor: Colors.black,
      gradient: isGradient ? const LinearGradient(
        colors: [Colors.red, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ) : null,
    );
  }
}