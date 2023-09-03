import 'package:flutter/material.dart';
import 'dart:math';

class TimeDialModel extends ChangeNotifier {
  TimeDialModel(
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

  void getVisibleNumbers() {
    var startIndex = selectedItem - numberOfVisibleItems ~/ 2;
    startIndex -= additionalItemsBuffer;
    for (int i = 0; i < numberOfVisibleItems + 2 * additionalItemsBuffer; i++) {
      visibleItems[i] = items[(startIndex + i) % items.length];
    }
  }

  double get angle => _angle;

  set angle(double newAngle) {
    _angle = newAngle;
    notifyListeners();
  }

  void addAngle(double additionalAngle) {
    _angle += additionalAngle;
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
