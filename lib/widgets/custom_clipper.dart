import 'package:flutter/material.dart';

// [CustomMessageClipper] clips the widget in a dialog box shape with a fully rounded notch at the center
class CustomMessageClipper extends CustomClipper<Path> {
  CustomMessageClipper({this.borderRadius = 25});
  final double borderRadius;

  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = 270;
    double rheight = height - height / 3; // Height where the notch starts
    double notchRadius = 25; // Radius of the rounded notch

    final path = Path()
      ..moveTo(0, rheight - borderRadius)
      ..cubicTo(0, rheight - borderRadius, 0, rheight, borderRadius,
          rheight) // Bottom-left curve
      ..lineTo((width / 2) - notchRadius,
          rheight) // Line up to the left edge of the notch
      ..arcToPoint(
        Offset((width / 2) + notchRadius, rheight), // Right side of the notch
        radius: Radius.circular(notchRadius),
        clockwise: false,
      ) // Draw the rounded notch at the center
      ..lineTo(width - borderRadius, rheight) // Continue path after the notch
      ..cubicTo(width - borderRadius, rheight, width, rheight, width,
          rheight - borderRadius) // Bottom-right curve
      ..lineTo(width, 0) // Right vertical line to top-right corner
      ..lineTo(0, 0) // Top horizontal line back to the starting point
      ..close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // Since the clipper does not have any mutable state,
    // it will always return true to ensure the clipper is always re-applied.
    // If the clipper had mutable state, you would compare it with `oldClipper`.
    return true;
  }
}
