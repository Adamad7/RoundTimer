import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:round_timer/time_dial/time_dial_controller.dart';
import 'package:round_timer/time_dial/time_dial.dart';
import 'package:round_timer/time_controller.dart';

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

final TimerController timerController = TimerController();

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
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.stop),
            ),
            IconButton(
              onPressed: () {
                timerController.pauseAnimation();
              },
              icon: const Icon(Icons.pause),
            ),
            IconButton(
              onPressed: () {
                timerController.animateCountdown();
              },
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
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
                  create: (context) => timerController.hoursController,
                  child: const TimeDial(height: 450),
                ),
                ChangeNotifierProvider(
                  create: (context) => timerController.minutesController,
                  child: const TimeDial(height: 380),
                ),
                ChangeNotifierProvider(
                  create: (context) => timerController.secondsController,
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
