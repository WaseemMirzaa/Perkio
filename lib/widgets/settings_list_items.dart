import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';

class SettingsListItems extends StatelessWidget {
    final String path;
  final String text;
  const SettingsListItems({required this.path, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide( width: 1, color: Color(0xFFE9E9E9)))
      ),
      child: Padding(
                        padding: const EdgeInsets.only(top: 30,bottom: 12),
                        child: Row(
                          children: [
                            const SpacerBoxHorizontal(width: 20),
                            ImageIcon(AssetImage(path),size: 20.sp,),
                            const SpacerBoxHorizontal(width: 20),
                            
                            Text(text, style: poppinsRegular(fontSize: 14.sp),)
                          ],
                        ),
                      ),
                    );
  }
}