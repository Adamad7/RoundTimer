import 'package:flutter/material.dart';
import 'dart:math';

class DialClipper extends CustomClipper<Path> {
  DialClipper({required this.dialWidth});
  final double dialWidth;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, size.height - dialWidth);
    path.lineTo(size.width, size.height);
    path.arcTo(
        Rect.fromCenter(
            center: Offset(size.width, size.height / 2),
            width: size.width * 2,
            height: size.height),
        0.5 * pi,
        pi,
        true);
    path.moveTo(size.width, 0);
    path.lineTo(size.width, dialWidth);

    path.arcTo(
        Rect.fromCenter(
            center: Offset(size.width, size.height / 2),
            width: size.width * 2 - dialWidth * 2,
            height: size.height - dialWidth * 2),
        1.5 * pi,
        -pi,
        true);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
