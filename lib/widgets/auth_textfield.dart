import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';

class TextFieldWidget extends StatefulWidget {
  final String text;
  final String? path;
  final String? onChangepath;
  final TextEditingController textController;
  final bool isPassword;
  final Function()? onEditComplete;
  final FocusNode? focusNode;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final bool isReadOnly;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool? isObscure;

  const TextFieldWidget({
    super.key,
    required this.text,
    this.path,
    this.onChangepath,
    required this.textController,
    this.onSubmit,
    this.onChanged,
    this.isPassword = false,
    this.onEditComplete,
    this.focusNode,
    this.keyboardType,
    this.prefixIcon,
    this.inputFormatters,
    this.isReadOnly = false,
    this.onTap,
    this.isObscure,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isTextObscured = false;

  @override
  void initState() {
    super.initState();
    // Set the initial state based on isObscure flag
    _isTextObscured = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _isTextObscured = !_isTextObscured;
    });
  }

  void _unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _unfocus(context),
      child: Container(
        height: 7.h,
        width: 100.w,
        padding: EdgeInsets.only(left: 2.w, right: 1.w),
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
          readOnly: widget.isReadOnly,
          obscureText: widget.isPassword && _isTextObscured,
          controller: widget.textController,
          onEditingComplete: widget.onEditComplete,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          onFieldSubmitted: widget.onSubmit,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          cursorColor: orange,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2.h),
            prefixIcon: widget.prefixIcon,
            hintText: widget.text,
            hintStyle:
                poppinsRegular(fontSize: 13, color: const Color(0xFF858585)),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: widget.isPassword
                ? Padding(
                    padding: const EdgeInsets.all(2),
                    child: GestureDetector(
                      onTap: _toggleObscureText,
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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: _isTextObscured
                            ? Image.asset(widget.path!, scale: 3)
                            : Image.asset(
                                widget.onChangepath!,
                                scale: 3,
                                color: const Color(0xFF858585),
                              ),
                      ),
                    ),
                  )
                : (widget.path.isEmptyOrNull
                    ? null
                    : Padding(
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
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Image.asset(widget.path!, scale: 3),
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
