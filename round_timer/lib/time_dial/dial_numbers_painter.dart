import 'package:flutter/material.dart';
import 'dart:math';

class DialNumbersPainter extends CustomPainter {
  DialNumbersPainter(
      {required this.numbers,
      required this.angle,
      this.leftHanded = false,
      required this.anglePerNumber,
      required this.dialWidth});
  final double angle;
  final List<String> numbers;
  final bool leftHanded;
  final double anglePerNumber;
  final double dialWidth;
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return angle != (oldDelegate as DialNumbersPainter).angle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(color: Colors.white, fontSize: 15);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    canvas.translate(size.width, size.height / 2);
    canvas.rotate(-pi / 2 - angle + anglePerNumber / 2 - anglePerNumber * 2);
    canvas.translate(-size.width, -size.height / 2);
    for (var i = 0; i < numbers.length; i++) {
      textPainter.text = TextSpan(text: numbers[i], style: textStyle);
      textPainter.layout();

      final textOffset =
          Offset((dialWidth - textPainter.width) / 2, size.height / 2 - textPainter.height / 2);
      textPainter.paint(canvas, textOffset);
      canvas.translate(size.width, size.height / 2);
      canvas.rotate(anglePerNumber);
      canvas.translate(-size.width, -size.height / 2);
    }
  }
}
