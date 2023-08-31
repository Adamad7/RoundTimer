import 'package:flutter/material.dart';

class TimeModel extends ChangeNotifier {
  TimeModel();

  int _seconds = 0;
  int get seconds => _seconds;
  set seconds(int value) {
    _seconds = value;
    notifyListeners();
  }

  int _minutes = 0;
  int get minutes => _minutes;
  set minutes(int value) {
    _minutes = value;
    notifyListeners();
  }

  int _hours = 0;
  int get hours => _hours;
  set hours(int value) {
    _hours = value;
    notifyListeners();
  }
}
