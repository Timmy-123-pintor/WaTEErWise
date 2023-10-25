import 'package:flutter/material.dart';
import 'dart:async';

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

class TimerProvider with ChangeNotifier {
  String _selectedDuration = 'Choose';
  int _timerDurationInSeconds = 0;
  Timer? _timer;

  String get selectedDuration => _selectedDuration;
  int get timerDurationInSeconds => _timerDurationInSeconds;

  int get daysLeft => (_timerDurationInSeconds / (24 * 60 * 60)).floor();
  int get hoursLeft =>
      ((_timerDurationInSeconds % (24 * 60 * 60)) / 3600).floor();
  int get minutesLeft => ((_timerDurationInSeconds % 3600) / 60).floor();

  void setDuration(String duration) {
    _selectedDuration = duration;

    if (duration == '1 Week') {
      _timerDurationInSeconds = 7 * 24 * 60 * 60;
    } else if (duration == '2 Weeks') {
      _timerDurationInSeconds = 14 * 24 * 60 * 60;
    } else if (duration == '1 Month') {
      _timerDurationInSeconds = 28 * 24 * 60 * 60;
    }

    notifyListeners();
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerDurationInSeconds > 0) {
        _timerDurationInSeconds--;
        notifyListeners();
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timerDurationInSeconds = 0;
    notifyListeners();
  }
}

class ButtonStateProvider with ChangeNotifier {
  bool _isSetButton = true;
  bool _isCancelButton = false;

  bool get isSetButton => _isSetButton;
  bool get isCancelButton => _isCancelButton;

  void setSetButton() {
    _isSetButton = true;
    _isCancelButton = false;
    notifyListeners();
  }

  void setCancelButton() {
    _isSetButton = false;
    _isCancelButton = true;
    notifyListeners();
  }
}
