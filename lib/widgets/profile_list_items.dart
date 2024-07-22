import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';

class ProfileListItems extends StatelessWidget {
  final String path;
  final String text;
  const ProfileListItems({required this.path, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide( width: 1, color: Color(0xFFE9E9E9)))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30,bottom: 12),
                        child: Row(
                          children: [
                            SpacerBoxHorizontal(width: 20),
                            Image.asset(path, scale: 3,),
                            SpacerBoxHorizontal(width: 20),
                            Text(text, style: poppinsRegular(fontSize: 20),)
                          ],
                        ),
                      ),
                    );
  }
}