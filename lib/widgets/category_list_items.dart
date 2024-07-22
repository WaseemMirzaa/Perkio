import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';

class CategoryListItems extends StatelessWidget {

  final String path;
  final String text;
  const CategoryListItems({required this.path, required this.text});

  @override
  Widget build(BuildContext context) {
    RxBool tapped = false.obs;
    return SizedBox(
      height: 140,
      child: GestureDetector(
        onTap: (){
          tapped.value = !tapped.value;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 90,
                              child: Image.asset(path ,scale: 3,)),
                              Text(text, style: poppinsRegular(fontSize: 13),),
                            Obx((){
                              return RoundCheckBox(
                              isChecked: tapped.value,
                              size: 22,
                              checkedWidget: Icon(Icons.check_rounded,size: 18,color: AppColors.whiteColor,),
                              onTap: (tapped){});
                            })
                          ],
                        ),
      ),
    );
  }
}