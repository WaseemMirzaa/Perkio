import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final double base = size.height * .4;

    const corner = Radius.circular(16);

    final path1 = Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(0, base, size.width, size.height,
            topLeft: corner, topRight: corner),
      );

    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.height / 2;

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(
        Path.combine(PathOperation.union, path1, circlePath), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
