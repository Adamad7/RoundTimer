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

  late final shadowBrush = Paint()
    ..color = Colors.black.withOpacity(0.4)
    ..strokeWidth = width
    ..style = PaintingStyle.stroke
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(leftHanded ? 0 : size.width, size.height / 2);
    Rect arcRect =
        Rect.fromCenter(center: center, width: size.width * 2 - width, height: size.height - width);
    double startAngle = 0.5 * pi;
    double sweepAngle = (leftHanded ? -1 : 1) * pi;

    // Draw shadow arc
    canvas.drawArc(
      arcRect.shift(const Offset(0, 0)),
      startAngle,
      sweepAngle,
      false,
      shadowBrush,
    );

    // Draw original arc
    canvas.drawArc(
      arcRect,
      startAngle,
      sweepAngle,
      false,
      brush,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
