import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';

class SelectionTile extends StatelessWidget {
  final String imgPath;
  final String text;
  const SelectionTile({required this.imgPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
                    height: 25.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                       borderRadius: BorderRadius.all(Radius.circular(14)),
                       boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 3)// changes position of shadow
                  ),
                                ],),
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(imgPath, scale: 3,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(text, style: poppinsMedium(fontSize: 16),),
                          )
                        ],
                       )
                  );
  }
}