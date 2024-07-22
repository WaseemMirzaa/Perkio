import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';

class CommonButton extends StatelessWidget {

    final VoidCallback onSwipe;
  final String text;
  const CommonButton({required this.onSwipe, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
                  height: 55,
                  decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          gradient: LinearGradient(
                        colors: [Colors.red, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                          
                  ),
                  child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            onSwipe();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: Image.asset(AppAssets.swipeImg,scale: 3,)
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: poppinsMedium(fontSize: 16, color: AppColors.whiteColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container( width: 35,)
                ],
                            ),
                          ),
                  ),
                );
  }
}