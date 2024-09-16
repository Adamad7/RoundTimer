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
  int selectedItem = 0;
  late AnimationController nearestNumberAnimationController;
  late Animation<double> nearestNumberAnimation;
  late AnimationController countdownAnimationController;
  late Animation<double> countdownAnimation;
  double countdownValue = 0.0;
  double countdownTotalAngle = 0.0;

  void getVisibleNumbers() {
    var startIndex = selectedItem - numberOfVisibleItems ~/ 2;
    startIndex -= additionalItemsBuffer;
    for (int i = 0; i < numberOfVisibleItems + 2 * additionalItemsBuffer; i++) {
      visibleItems[i] = items[(startIndex + i) % items.length];
    }
  }

  void initAnimationControllers() {
    // nearestNumberAnimation =
    //     Tween<double>(begin: angle, end: closestAngle).animate(nearestNumberAnimationController)
    //       ..addListener(() {
    //         _angle = nearestNumberAnimation.value;
    //         print("closest angle: $angle, new angle: $_angle");
    //       })
    //       ..addStatusListener((status) {
    //         if (status == AnimationStatus.completed) {
    //           _angle = 0;
    //           selectedItem = (selectedItem + 1) % items.length;
    //           getVisibleNumbers();
    //           notifyListeners();
    //         }
    //       });

    // nearestNumberAnimation =
    //     Tween<double>(begin: angle, end: closestAngle).animate(nearestNumberAnimationController)
    //       ..addListener(() {
    //         angle = nearestNumberAnimation.value;
    //       })
    //       ..addStatusListener((status) {
    //         if (status == AnimationStatus.completed) {
    //           getVisibleNumbers();
    //           angle = 0;
    //         }
    //       });

    // countdownAnimation =
    //     Tween<double>(begin: 0, end: countdownTotalAngle).animate(countdownAnimationController)
    //       ..addListener(() {
    //         _angle += (countdownAnimation.value - countdownValue);
    //         if (_angle <= -(anglePerItem / 2.0)) {
    //           selectedItem = (selectedItem - 1) % 60;
    //           getVisibleNumbers();
    //           notifyListeners();
    //         }
    //         countdownValue = countdownAnimation.value;
    //       })
    //       ..addStatusListener((status) {
    //         if (status == AnimationStatus.completed) {
    //           angle = 0;
    //         }
    //       });
  }

  void animateToClosestNumber() {
    nearestNumberAnimationController.reset();
    nearestNumberAnimation =
        Tween<double>(begin: angle, end: closestAngle).animate(nearestNumberAnimationController)
          ..addListener(() {
            angle = nearestNumberAnimation.value;
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              // if (closestAngle == anglePerItem) {
              //   selectedItem = (selectedItem + 1) % items.length;
              // } else if (closestAngle == -anglePerItem) {
              //   selectedItem = (selectedItem - 1) % items.length;
              // }
              getVisibleNumbers();
              angle = 0;
            }
          });
    // animation = Tween<double>(begin: angle, end: closestAngle).animate(animationController)
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {

    //         angle = 0;
    //         selectedItem = (selectedItem + 1) % items.length;
    //         getVisibleNumbers();
    //         notifyListeners();

    //     }
    //   })
    //   ..addListener(() {

    //       angle = animation.value;

    //   });
    // ..addListener(() {
    //   angle = animation.value;
    // })
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     getVisibleNumbers();
    //     angle = 0;
    //   }
    // });

    nearestNumberAnimationController.forward();
  }

  void animateCountdown({int fullRotations = 0, int perItemAnimationDuration = 1}) {
    countdownAnimationController.reset();
    countdownAnimationController.duration =
        Duration(seconds: (fullRotations * items.length + selectedItem) * perItemAnimationDuration);
    countdownAnimation =
        Tween<double>(begin: 0, end: (fullRotations * items.length + selectedItem) * anglePerItem)
            .animate(countdownAnimationController)
          ..addListener(() {
            addAngle(-(countdownAnimation.value - countdownValue));
            // _angle -= (countdownAnimation.value - countdownValue);
            // if (_angle <= -(anglePerItem / 2.0)) {
            //   selectedItem = (selectedItem - 1) % 60;
            //   angle = 0;
            //   // print(selectedItem);
            //   getVisibleNumbers();
            //   // notifyListeners();
            // }
            countdownValue = countdownAnimation.value;
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              angle = 0;
              countdownValue = 0;
            }
          });

    countdownAnimationController.forward();
    // double previousValue = 0;
    // animationController.reset();

    // animation = Tween<double>(
    //         begin: 0,
    //         // end: (fullRotations * items.length * anglePerItem) + (anglePerItem * selectedItem))
    //         end: (fullRotations * items.length + selectedItem) * anglePerItem)
    //     .animate(animationController)
    //   ..addListener(() {
    //     // print(
    //     //     "animation value: ${animation.value}, previous value: $previousValue, angle: $angle, selectedItem: $selectedItem");
    //     // addAngle((animation.value - previousValue));
    //     _angle += (animation.value - previousValue);
    //     // if (perItemAnimationDuration == 1) {
    //     //   print(animation.value - previousValue);
    //     // }
    //     if (_angle <= -(anglePerItem / 2.0)) {
    //       selectedItem = (selectedItem - 1) % 60;
    //       getVisibleNumbers();
    //       notifyListeners();
    //     }

    //     previousValue = animation.value;
    //   })
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       angle = 0;
    //       animationController.duration = const Duration(milliseconds: 100);
    //     }
    //   });

    // animationController.duration =
    //     Duration(seconds: (fullRotations * items.length + selectedItem) * perItemAnimationDuration);
    // animationController.forward();
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
    notifyListeners();
  }

  void addAngle(double additionalAngle) {
    _angle += additionalAngle;

    // if (_angle >= anglePerItem) {
    //   angle = 0;
    //   selectedItem = (selectedItem + 1) % 60;
    //   getVisibleNumbers();
    // } else if (_angle <= -anglePerItem) {
    //   angle = 0;
    //   selectedItem = (selectedItem - 1) % 60;
    //   getVisibleNumbers();
    // }

    if (_angle >= anglePerItem) {
      angle = 0;
      selectedItem = (selectedItem + 1) % 60;
      getVisibleNumbers();
    } else if (_angle <= -anglePerItem) {
      angle = 0;
      selectedItem = (selectedItem - 1) % 60;
      getVisibleNumbers();
    }

    notifyListeners();
  }

  double get closestAngle {
    double closestAngle = 0;
    if (_angle > anglePerItem / 2) {
      closestAngle = anglePerItem;
      selectedItem = (selectedItem + 1) % items.length;
    } else if (_angle < -anglePerItem / 2) {
      closestAngle = -anglePerItem;
      selectedItem = (selectedItem - 1) % items.length;
    }
    return closestAngle;
  }
}
