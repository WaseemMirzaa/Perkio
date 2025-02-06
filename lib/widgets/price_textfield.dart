import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';

class PriceTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const PriceTextFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: orange,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.only(
                left: 10,
                top: 5
              ),
          hintText: "Enter Price",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
