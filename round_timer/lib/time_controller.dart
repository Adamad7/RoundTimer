import 'dart:async';

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
  bool countdownInProgress = false;
  bool countdownPaused = false;
  final TimeDialController hoursController;
  final TimeDialController minutesController;
  final TimeDialController secondsController;
  Timer countdownTimer = Timer(Duration.zero, () {});

  void startCountdown() {
    countdownTimer = Timer(
        Duration(
            hours: hoursController.selectedItem,
            minutes: minutesController.selectedItem,
            milliseconds: secondsController.selectedItem * 100), () {
      countdownInProgress = false;
      countdownPaused = false;
      notifyListeners();
    });
    if (countdownInProgress) {
      countdownPaused = false;
      hoursController.resumeCountdownAnimation();
      minutesController.resumeCountdownAnimation();
      secondsController.resumeCountdownAnimation();
    } else {
      // countdownInProgress = false;
      // countdownPaused = false;
      // notifyListeners();
      countdownInProgress = true;
      hoursController.animateCountdown(perItemAnimationDuration: 3600);
      minutesController.animateCountdown(
          fullRotations: hoursController.selectedItem, perItemAnimationDuration: 60);
      secondsController.animateCountdown(
          fullRotations: (hoursController.selectedItem * 60) + minutesController.selectedItem,
          perItemAnimationDuration: 1);
    }
    notifyListeners();
  }

  void pauseCountdown() {
    countdownPaused = true;
    countdownTimer.cancel();
    hoursController.pauseCountdownAnimation();
    minutesController.pauseCountdownAnimation();
    secondsController.pauseCountdownAnimation();
    notifyListeners();
  }

  void stopCountdown() {
    countdownInProgress = false;
    countdownPaused = false;
    countdownTimer.cancel();
    // hoursController.stopCountdownAnimation();
    // minutesController.stopCountdownAnimation();
    // secondsController.stopCountdownAnimation();
    notifyListeners();
  }
}
