import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';

class CommonTextField extends StatelessWidget {
  final String text;
  const CommonTextField({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 3)
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: text,
                      hintStyle: poppinsRegular(fontSize: 13,color: Color(0xFF858585)),
                      border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            );
  }
}