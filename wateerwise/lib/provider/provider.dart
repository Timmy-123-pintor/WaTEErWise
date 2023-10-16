import 'package:flutter/material.dart';

class ProgressProvider extends ChangeNotifier {
  double _maxValue = 100;

  double get maxValue => _maxValue;

  void setMaxValue(double newValue) {
    _maxValue = newValue;
    notifyListeners();
  }
}

class PhoneNumberProvider extends ChangeNotifier {
  String _phoneNumber = "";

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }
}
