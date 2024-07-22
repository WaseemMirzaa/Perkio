import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12,top: 52),
      child: Row(
                        children: [
                          Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 3)
                            )
                          ],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(Icons.arrow_back),
                            ),
                            
                        ],
                      ),
    );
  }
}