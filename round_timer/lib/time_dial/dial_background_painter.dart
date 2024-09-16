import 'package:flutter/material.dart';
import 'dart:math';

class DialBackgroundPainter extends CustomPainter {
  DialBackgroundPainter({required this.color, required this.width, this.leftHanded = false});

  final Color color;
  final double width;
  final bool leftHanded;

  late final brush = Paint()
    ..color = color
    ..strokeWidth = width
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(leftHanded ? 0 : size.width, size.height / 2);
    canvas.drawArc(
        Rect.fromCenter(center: center, width: size.width * 2 - width, height: size.height - width),
        0.5 * pi,
        (leftHanded ? -1 : 1) * pi,
        false,
        brush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
