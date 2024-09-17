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
        Tween<double>(begin: angle, end: closestAngle).animate(nearestNumberAnimationController)
          ..addListener(() {
            _angle = nearestNumberAnimation.value;
            notifyListeners();
          });
    nearestNumberAnimationController.reset();
    nearestNumberAnimationController.forward();
  }

  void animateCountdown({int fullRotations = 0, int perItemAnimationDuration = 1}) {
    countdownAnimationController.duration =
        Duration(seconds: (fullRotations * items.length + selectedItem) * perItemAnimationDuration);
    countdownAnimation =
        Tween<double>(begin: 0, end: (fullRotations * items.length + selectedItem) * anglePerItem)
            .animate(countdownAnimationController)
          ..addListener(() {
            addAngle(-(countdownAnimation.value - angleAccumulator));
            // _angle -= (countdownAnimation.value - countdownValue);
            // if (_angle <= -(anglePerItem / 2.0)) {
            //   selectedItem = (selectedItem - 1) % 60;
            //   angle = 0;
            //   // print(selectedItem);
            //   getVisibleNumbers();
            //   // notifyListeners();
            // }
            angleAccumulator = countdownAnimation.value;
          });
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     angle = 0;
    //     angleAccumulator = 0;
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
