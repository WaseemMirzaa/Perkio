import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/views/test.dart';
import 'package:skhickens_app/widgets/customize_slide_btn_comp.dart';
import 'package:slide_to_act/slide_to_act.dart';

class ButtonWidget extends StatelessWidget {
  bool check;
  final VoidCallback onSwipe;
  final String text;
   ButtonWidget({super.key,this.check = true, required this.onSwipe, required this.text});
  final GlobalKey<SlideActionState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return check ? CustomSlideActionButton(
      key: _key,
      height: 7.h,
      onSubmit: () {
        Future.delayed(
          const Duration(seconds: 1),
              () => _key.currentState?.reset(),
        );
        onSwipe();
      },
      text: text,
      sliderButtonIcon: Container(
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Image.asset(AppAssets.swipeImg,scale: 3,)
      ),
      sliderButtonIconPadding: 0,
      textStyle: poppinsBold(fontSize: 14),
      outerColor:  Colors.grey[200],
      innerColor: Colors.black,
    ):CustomSlideAction(
      key: _key,
      height: 7.h,
      onSubmit: () {
        Future.delayed(
          const Duration(seconds: 1),
              () => _key.currentState?.reset(),
        );
        onSwipe();
      },
      text: text,
      sliderButtonIcon: Container(
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Image.asset(AppAssets.swipeImg,scale: 3,)
      ),
      sliderButtonIconPadding: 0,
      textStyle: poppinsBold(fontSize: 14),
      outerColor:  Colors.grey[200],
      innerColor: Colors.black,
    );
  }
}