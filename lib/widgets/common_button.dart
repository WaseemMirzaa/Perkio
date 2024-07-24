import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/customize_slide_btn_comp.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CommonButton extends StatelessWidget {

    final VoidCallback onSwipe;
  final String text;
   CommonButton({super.key, required this.onSwipe, required this.text});
    final GlobalKey<SlideActionState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return CustomSlideActionButton(
      key: _key,
      height: 7.h,
      gradient: const LinearGradient(
        colors: [Colors.red, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onSubmit: () {
        onSwipe();
        Future.delayed(
          const Duration(seconds: 1), () => _key.currentState?.reset(),
        );
        },
      text: text,
      sliderButtonIcon: Container(
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor
          ),
          child: Image.asset(AppAssets.swipeImg,scale: 3,)
      ),
      sliderButtonIconPadding: 0,
      textStyle: poppinsBold(fontSize: 14,color: AppColors.whiteColor),
      outerColor:  Colors.grey[200],
      innerColor: Colors.black,
    );
  }
}