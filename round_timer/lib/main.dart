import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const RoundTimer());
}

class RoundTimer extends StatelessWidget {
  const RoundTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer"),
      ),
      body: const Center(child: TimeDial(height: 400, width: 200)),
      backgroundColor: Colors.black,
    );
  }
}

class TimeDial extends StatefulWidget {
  const TimeDial({super.key, required this.width, required this.height});
  final double width;
  final double height;

  @override
  State<TimeDial> createState() => _TimeDialState();
}

class _TimeDialState extends State<TimeDial> {
  List<String> getNumbers() {
    List<String> numbers = [];
    for (int i = 0; i < 10; i++) {
      numbers.add(" " + i.toString());
    }
    for (int i = 10; i < 60; i++) {
      numbers.add(i.toString());
    }
    return numbers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: const BoxDecoration(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(360), bottomLeft: Radius.circular(360)),
            color: Colors.blue),
        // child: CustomPaint(
        //   painter: DialBackgroundPainter(color: Colors.red, width: 15),
        // )
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(widget.width, widget.height),
                painter: DialBackgroundPainter(color: Colors.red, width: 15),
              ),
              CustomPaint(
                size: Size(widget.width, widget.height),
                painter: DialNumbersPainter(numbers: getNumbers(), angle: 0, leftHanded: false),
              ),
            ],
          ),
        ));
  }
}

class DialNumbersPainter extends CustomPainter {
  DialNumbersPainter({required this.numbers, required this.angle, this.leftHanded = false}) {
    anglePerNumber = 2 * pi / numbers.length;
  }
  double angle;
  List<String> numbers;
  bool leftHanded;
  double anglePerNumber = 0;
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(color: Colors.white, fontSize: 14);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    // final Offset center = Offset(leftHanded ? 0 : size.width, size.height / 2);

    for (var i = 0; i < numbers.length; i++) {
      textPainter.text = TextSpan(text: numbers[i], style: textStyle);
      textPainter.layout();
      canvas.translate(size.width, size.height / 2);
      canvas.rotate(anglePerNumber);
      canvas.translate(-size.width, -size.height / 2);

      final textOffset = Offset(
          textPainter.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2);
      // final textOffset = Offset(-50, 0);
      // final textOffset = Offset(center.dx + radius * cos(textAngle) - textPainter.width / 2,
      //     center.dy + radius * sin(textAngle) - textPainter.height / 2);
      textPainter.paint(canvas, textOffset);
    }
    canvas.rotate(angle);
  }
}

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
