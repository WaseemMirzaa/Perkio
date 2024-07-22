import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';

class CustomShapeContainer extends StatelessWidget {

  const CustomShapeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.header, height: 210,);
  }
}