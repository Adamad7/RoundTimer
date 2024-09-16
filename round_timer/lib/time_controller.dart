import 'package:flutter/material.dart';

import 'package:round_timer/time_dial/time_dial_controller.dart';

class TimerController extends ChangeNotifier {
  TimerController(
      {this.minHour = 0,
      this.maxHour = 59,
      this.minMinute = 0,
      this.maxMinute = 59,
      this.minSecond = 0,
      this.maxSecond = 59})
      : hoursController = TimeDialController(
            items: List.generate((maxHour - minHour) + 1, (int index) => index.toString()),
            numberOfVisibleItems: 11),
        minutesController = TimeDialController(
            items: List.generate((maxMinute - minMinute) + 1, (int index) => index.toString()),
            numberOfVisibleItems: 11),
        secondsController = TimeDialController(
            items: List.generate((maxSecond - minSecond) + 1, (int index) => index.toString()),
            numberOfVisibleItems: 11);
  final int minHour;
  final int maxHour;
  final int minMinute;
  final int maxMinute;
  final int minSecond;
  final int maxSecond;
  bool countDownInProgress = false;
  final TimeDialController hoursController;
  final TimeDialController minutesController;
  final TimeDialController secondsController;

  void animateCountdown() {
    if (countDownInProgress) {
      hoursController.resumeCountdownAnimation();
      minutesController.resumeCountdownAnimation();
      secondsController.resumeCountdownAnimation();
    } else {
      countDownInProgress = true;
      hoursController.animateCountdown(perItemAnimationDuration: 3600);
      minutesController.animateCountdown(
          fullRotations: hoursController.selectedItem, perItemAnimationDuration: 60);
      secondsController.animateCountdown(
          fullRotations: (hoursController.selectedItem * 60) + minutesController.selectedItem,
          perItemAnimationDuration: 1);
    }
  }

  void pauseAnimation() {
    hoursController.pauseCountdownAnimation();
    minutesController.pauseCountdownAnimation();
    secondsController.pauseCountdownAnimation();
  }
}
