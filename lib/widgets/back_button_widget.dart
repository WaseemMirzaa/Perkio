import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';

class BackButtonWidget extends StatelessWidget {
  BackButtonWidget({super.key,this.padding,  this.onBack});
  EdgeInsetsGeometry? padding;
  Function()? onBack;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 12,right: 12,bottom: 12,top: 52),
      child: GestureDetector(
        onTap: onBack ?? (){
          Navigator.pop(context);
        },
        child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3)
          )
        ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.arrow_back),
          ),
      ),
    );
  }
}