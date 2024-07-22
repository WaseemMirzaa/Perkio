import 'package:flutter/material.dart';

class SpacerBoxVertical extends StatelessWidget {
  final double height;

  const SpacerBoxVertical({required this.height, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class SpacerBoxHorizontal extends StatelessWidget {
  final double width;

  const SpacerBoxHorizontal({required this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}