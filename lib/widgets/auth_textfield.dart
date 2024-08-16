import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';

class TextFieldWidget extends StatelessWidget {
  final String text;
  final String? path;
  final TextEditingController textController;
  final bool isPassword;
  final Function()? onEditComplete;
  final FocusNode? focusNode;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final bool isReadOnly;
  final Function()? onTap;
  List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  TextFieldWidget({super.key,
    required this.text,this.path, required this.textController,
    this.onSubmit,this.onChanged,
    this.isPassword = false,this.onEditComplete, this.focusNode, this.keyboardType,
    this.prefixIcon,
     this.inputFormatters,
    this.isReadOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
              height: 7.h,
              width: 100.w,
              padding: EdgeInsets.only(left: 2.w,right: 1.w,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3)
                  )
                ]
              ),
              child: TextFormField(
                readOnly: isReadOnly,
                obscureText: isPassword,
                controller: textController,
                onEditingComplete: onEditComplete,
                focusNode: focusNode,
                keyboardType: keyboardType,
                onFieldSubmitted: onSubmit,
                onChanged: onChanged,
                onTap: onTap,
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(2.h),
                  prefixIcon: prefixIcon,
                  hintText: text,
                  hintStyle: poppinsRegular(fontSize: 13,color: const Color(0xFF858585)),
                  border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,

                  suffixIcon: path.isEmptyOrNull ? null : Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      height: 38.sp,
                      width: 38.sp,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3)
                            )
                          ]
                      ),
                      child: Image.asset(path!, scale: 3,),
                    ),
                  )
                ),

              ),
            );
  }
}