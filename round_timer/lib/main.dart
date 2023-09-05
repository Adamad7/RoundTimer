import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:round_timer/time_dial_model.dart';

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

List<String> getNumbers() {
  List<String> numbers = [];
  for (int i = 0; i < 10; i++) {
    numbers.add(" ${i.toString()}");
  }
  for (int i = 10; i < 60; i++) {
    numbers.add(i.toString());
  }
  return numbers;
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
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 500,
              child: Stack(alignment: Alignment.centerRight, children: [
                ChangeNotifierProvider(
                  create: (context) => TimeDialModel(items: getNumbers(), numberOfVisibleItems: 11),
                  child: const TimeDial(height: 450),
                ),
                ChangeNotifierProvider(
                  create: (context) => TimeDialModel(items: getNumbers(), numberOfVisibleItems: 11),
                  child: const TimeDial(height: 380),
                ),
                ChangeNotifierProvider(
                  create: (context) => TimeDialModel(items: getNumbers(), numberOfVisibleItems: 11),
                  child: const TimeDial(height: 310),
                ),
              ]),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class TimeDial extends StatefulWidget {
  const TimeDial({super.key, required this.height}) : width = height / 2;
  final double width;
  final double height;

  @override
  State<TimeDial> createState() => _TimeDialState();
}

class _TimeDialState extends State<TimeDial> with SingleTickerProviderStateMixin {
  late TimeDialModel dialModel;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    dialModel = Provider.of<TimeDialModel>(context, listen: false);
  }

  void animateToClosestNumber() {
    animation =
        Tween<double>(begin: dialModel.angle, end: dialModel.closestAngle).animate(controller)
          ..addListener(() {
            dialModel.angle = animation.value;
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              dialModel.getVisibleNumbers();
              dialModel.angle = 0;
            }
          });
    controller.reset();

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(360), bottomLeft: Radius.circular(360)),
          color: Colors.blue,
        ),
        child: ClipPath(
          clipper: DialClipper(dialWidth: 20),
          child: GestureDetector(
            onPanUpdate: (details) {
              dialModel.addAngle((details.delta.dy -
                      (details.localPosition.dy > widget.height / 2 ? -1 : 1) * details.delta.dx) /
                  widget.width);
            },
            onPanEnd: (details) => animateToClosestNumber(),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: DialBackgroundPainter(color: Colors.red, width: 20),
                ),
                Consumer<TimeDialModel>(
                  builder: (context, model, child) {
                    return CustomPaint(
                      size: Size(widget.width, widget.height),
                      painter: DialNumbersPainter(
                          numbers: model.visibleItems,
                          angle: model.angle,
                          leftHanded: false,
                          anglePerNumber: model.anglePerItem,
                          dialWidth: 20),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

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
