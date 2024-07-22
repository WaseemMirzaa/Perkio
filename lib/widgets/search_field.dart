import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 40,
                      width: 40,
                                  
                                  child: Image.asset(AppAssets.searchImg, scale: 3,),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: TempLanguage.txtSearch,
                        hintStyle: poppinsRegular(fontSize: 13,color: Color(0xFF858585)),
                        border: InputBorder.none, 
                                    enabledBorder: InputBorder.none, 
                                    focusedBorder: InputBorder.none,
                      ),
                    ),
                    
                  ),
                  

                ],
              ),
            );
  }
}