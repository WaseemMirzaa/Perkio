import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';

class LoginButtonWidget extends StatelessWidget {

  final VoidCallback onSwipe;
  final String text;
  const LoginButtonWidget({required this.onSwipe, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
                  height: 55,
                  decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.grey[200],
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
                  Expanded(
                    child: Text(
                      text,
                      style: poppinsMedium(fontSize: 16),
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