import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wateerwise/components/WaterLimit/limitSummary.dart';

class ProgressProvider extends ChangeNotifier {
  double _maxValue = 100;

  double get maxValue => _maxValue;

  void setMaxValue(double newValue) {
    _maxValue = newValue;
    notifyListeners();
  }

  String _selectedValue = 'Choose';
  String get selectedValue => _selectedValue;
  set selectedValue(String value) {
    _selectedValue = value;
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

class SummaryDialogProvider with ChangeNotifier {
  void showSummaryDialog(
    BuildContext context,
    String cubicMeter,
    String timeDuration,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return SummaryDialog(
          cubicMeter: double.tryParse(cubicMeter) ?? 0,
          timeDuration: timeDuration,
        );
      },
    );
  }
}

class WaterConsumptionProvider with ChangeNotifier {
  double _totalLiters = 0.0;

  double get totalLiters => _totalLiters;

  set totalLiters(double value) {
    _totalLiters = value;
    notifyListeners();
  }

  Future<void> fetchSensorData(String userEmail, String sensorId) async {
    String url =
        'http://localhost:3000/api/sensor/$userEmail/$sensorId/totalLiters';
    Map<String, dynamic> data = await fetchData(url);

    if (data.containsKey('totalLiters')) {
      totalLiters = data['totalLiters'];
    } else {
      if (kDebugMode) {
        print('Error: Unexpected data format');
      }
    }
  }

  Future<Map<String, dynamic>> fetchData(String url) async {
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          print('Error: ${response.reasonPhrase}');
        }
        return {};
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
      return {};
    }
  }
}
