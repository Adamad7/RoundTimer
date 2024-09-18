import 'package:flutter/material.dart';
import 'dart:math';

class DialClipper extends CustomClipper<Path> {
  DialClipper({required this.dialWidth, required this.shadowWidth});
  final double dialWidth;
  final double shadowWidth;
  @override
  Path getClip(Size size) {
    Path path = Path();
    double totalWidth = dialWidth + shadowWidth;

    // Move to the bottom-right corner, accounting for shadow width
    path.moveTo(size.width, size.height - totalWidth);
    path.lineTo(size.width, size.height);

    // Draw the outer arc, accounting for shadow width
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width, size.height / 2),
        width: size.width * 2 + shadowWidth * 2,
        height: size.height + shadowWidth * 2,
      ),
      0.5 * pi,
      pi,
      true,
    );

    // Move to the top-right corner, accounting for shadow width
    path.moveTo(size.width, 0);
    path.lineTo(size.width, totalWidth);

    // Draw the inner arc, accounting for shadow width
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width, size.height / 2),
        width: size.width * 2 - totalWidth * 2,
        height: size.height - totalWidth * 2,
      ),
      1.5 * pi,
      -pi,
      true,
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
