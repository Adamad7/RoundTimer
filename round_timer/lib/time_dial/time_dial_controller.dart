import 'package:flutter/material.dart';
import 'dart:math';

class TimeDialController extends ChangeNotifier {
  TimeDialController(
      {required this.items, required this.numberOfVisibleItems, this.additionalItemsBuffer = 2}) {
    visibleItems = List<String>.filled(numberOfVisibleItems + 2 * additionalItemsBuffer, '');
    anglePerItem = pi / numberOfVisibleItems;
    getVisibleNumbers();
  }

  late final List<String> items;
  late List<String> visibleItems;
  final int numberOfVisibleItems;
  final int additionalItemsBuffer;
  late final double anglePerItem;
  double _angle = 0;
  int _selectedItem = 0;
  late AnimationController nearestNumberAnimationController;
  late Animation<double> nearestNumberAnimation;
  late AnimationController countdownAnimationController;
  late Animation<double> countdownAnimation;
  double angleAccumulator = 0.0;
  double countdownTotalAngle = 0.0;
  bool isItemChangeBlocked = false;

  void getVisibleNumbers() {
    var startIndex = selectedItem - numberOfVisibleItems ~/ 2;
    startIndex -= additionalItemsBuffer;
    for (int i = 0; i < numberOfVisibleItems + 2 * additionalItemsBuffer; i++) {
      visibleItems[i] = items[(startIndex + i) % items.length];
    }
  }

  void animateToClosestNumber() {
    nearestNumberAnimation =
        Tween<double>(begin: angle, end: closestAngle).animate(nearestNumberAnimationController);
    // ..addListener(() {
    //   _angle = nearestNumberAnimation.value;
    //   notifyListeners();
    // });
    nearestNumberAnimationController.reset();
    nearestNumberAnimationController.forward();
  }

  void initAnimationListeners() {
    nearestNumberAnimationController.addListener(() {
      _angle = nearestNumberAnimation.value;
      notifyListeners();
    });

    countdownAnimationController
      ..addListener(() {
        // print(
        //     "angle: $_angle, animation value: ${countdownAnimation.value}, accumulator: $angleAccumulator, sum: ${angle - (countdownAnimation.value - angleAccumulator)}");

        addAngle(-(countdownAnimation.value - angleAccumulator));
        angleAccumulator = countdownAnimation.value;
        // print("angleAccumulator: $angleAccumulator");
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print("end angle: $_angle");
          print("selected item: $selectedItem");
          angleAccumulator = 0;
          // angle = 0;
          // angleAccumulator = 0;
        }
      });
  }

  void animateCountdown({int fullRotations = 0, int perItemAnimationDuration = 1}) {
    // print("start angle: $_angle");
    // print("calculated total angle: ${(fullRotations * items.length + selectedItem)}");
    print("currentTotalAngle: ${_selectedItem * anglePerItem}");
    print(
        "End item: ${selectedItem - (fullRotations * items.length + selectedItem) * anglePerItem}");
    countdownAnimationController.duration = Duration(
        milliseconds:
            (fullRotations * items.length + selectedItem) * perItemAnimationDuration * 100);

    countdownAnimation = Tween<double>(
            begin: 0, end: (fullRotations * items.length + selectedItem) * (anglePerItem + 0.009))
        .animate(countdownAnimationController);
    // ..addListener(() {
    //   print(
    //       "angle: $_angle, animation value: ${countdownAnimation.value}, accumulator: $angleAccumulator, sum: ${angle - (countdownAnimation.value - angleAccumulator)}");
    //   addAngle(-(countdownAnimation.value - angleAccumulator));
    //   // print("animation value: ${countdownAnimation.value}");
    //   // _angle -= (countdownAnimation.value - countdownValue);
    //   // if (_angle <= -(anglePerItem / 2.0)) {
    //   //   selectedItem = (selectedItem - 1) % 60;
    //   //   angle = 0;
    //   //   // print(selectedItem);
    //   //   getVisibleNumbers();
    //   //   // notifyListeners();
    //   // }
    //   angleAccumulator = countdownAnimation.value;
    // })
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     print("end angle: $_angle");
    //     print("selected item: $selectedItem");
    //     // angle = 0;
    //     // angleAccumulator = 0;
    //   }
    // });
    countdownAnimationController.reset();
    countdownAnimationController.forward();
  }

  void pauseCountdownAnimation() {
    countdownAnimationController.stop();
  }

  void resumeCountdownAnimation() {
    countdownAnimationController.forward();
  }

  double get angle => _angle;

  set angle(double newAngle) {
    _angle = newAngle;

    if (_angle > anglePerItem / 2 && !isItemChangeBlocked) {
      selectedItem = (selectedItem + 1) % items.length;
      isItemChangeBlocked = true;
    } else if (_angle < -anglePerItem / 2 && !isItemChangeBlocked) {
      selectedItem = (selectedItem - 1) % items.length;
      isItemChangeBlocked = true;
    }

    if (_angle >= anglePerItem) {
      // selectedItem = (selectedItem + 1) % items.length;
      isItemChangeBlocked = false;
      _angle = 0;
      getVisibleNumbers();
    } else if (_angle <= -anglePerItem) {
      isItemChangeBlocked = false;
      // selectedItem = (selectedItem - 1) % items.length;
      _angle = 0;
      getVisibleNumbers();
    }
    // print("selectedItem: $selectedItem, angle: $_angle");

    // if (_angle >= anglePerItem) {
    //   _angle = 0;
    // } else if (_angle <= -anglePerItem) {
    //   _angle = 0;
    // }
    notifyListeners();
  }

  set selectedItem(int newSelectedItem) {
    _selectedItem = newSelectedItem;
    // print("selectedItem: $selectedItem");
    // getVisibleNumbers();
  }

  int get selectedItem => _selectedItem;

  void addAngle(double additionalAngle) {
    // _angle += additionalAngle;
    angle += additionalAngle;

    // if (_angle >= anglePerItem) {
    //   angle = 0;
    //   selectedItem = (selectedItem + 1) % 60;
    //   // getVisibleNumbers();
    // } else if (_angle <= -anglePerItem) {
    //   angle = 0;
    //   selectedItem = (selectedItem - 1) % 60;
    //   // getVisibleNumbers();
    // }

    // if (_angle >= anglePerItem) {
    //   _angle = 0;
    //   selectedItem = (selectedItem + 1) % 60;
    // } else if (_angle <= -anglePerItem) {
    //   _angle = 0;
    //   selectedItem = (selectedItem - 1) % 60;
    // }

    // notifyListeners();
  }

  double get closestAngle {
    if (_angle >= anglePerItem / 2) {
      return anglePerItem;
      // selectedItem = (selectedItem + 1) % items.length;
    } else if (_angle <= -anglePerItem / 2) {
      return -anglePerItem;
      // selectedItem = (selectedItem - 1) % items.length;
    } else {
      return 0;
    }
  }
}
