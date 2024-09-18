import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:round_timer/time_dial/time_dial_controller.dart';
import 'package:round_timer/time_dial/dial_background_painter.dart';
import 'package:round_timer/time_dial/dial_numbers_painter.dart';
import 'package:round_timer/time_dial/dial_clipper.dart';

class TimeDial extends StatefulWidget {
  const TimeDial({super.key, required this.height}) : width = height / 2;
  final double width;
  final double height;

  @override
  State<TimeDial> createState() => _TimeDialState();
}

class _TimeDialState extends State<TimeDial> with TickerProviderStateMixin {
  late TimeDialController dialController;

  @override
  void initState() {
    super.initState();
    dialController = Provider.of<TimeDialController>(context, listen: false);
    dialController.countdownAnimationController =
        AnimationController(duration: const Duration(milliseconds: 0), vsync: this);
    dialController.nearestNumberAnimationController =
        AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    dialController.initAnimationListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(360), bottomLeft: Radius.circular(360)),
          // color: Colors.blue,
        ),
        child: ClipPath(
          clipper: DialClipper(dialWidth: 20, shadowWidth: 6),
          child: Consumer<TimeDialController>(builder: (context, controller, child) {
            return GestureDetector(
              onPanUpdate: (details) {
                controller.addAngle((details.delta.dy -
                        (details.localPosition.dy > widget.height / 2 ? -1 : 1) *
                            details.delta.dx) /
                    widget.width);
              },
              onPanEnd: (details) => controller.animateToClosestNumber(),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter:
                        DialBackgroundPainter(color: Color.fromARGB(255, 53, 53, 53), width: 20),
                  ),
                  CustomPaint(
                    size: Size(widget.width, widget.height),
                    painter: DialNumbersPainter(
                        numbers: controller.visibleItems,
                        angle: controller.angle,
                        leftHanded: false,
                        anglePerNumber: controller.anglePerItem,
                        dialWidth: 20),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
