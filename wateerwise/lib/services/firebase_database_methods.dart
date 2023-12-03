import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseMethods {
  final FirebaseAuth _auth;
  final DatabaseReference _dbRef;

  FirebaseDatabaseMethods(this._auth, this._dbRef);

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  User get user => _auth.currentUser!;

  DatabaseReference _getConsumptionReference(DateTime date) {
    String year = date.year.toString();
    String monthName = months[date.month - 1];
    String day = date.day.toString().padLeft(2, '0');

    return _dbRef
        .child('waterConsumption')
        .child(user.uid)
        .child(year)
        .child(monthName)
        .child(day);
  }

  DatabaseReference _getMonthReference(int year, int month) {
    String monthName = months[month - 1];
    return _dbRef
        .child('waterConsumption')
        .child(user.uid)
        .child(year.toString())
        .child(monthName);
  }

  Future<void> storeDailyConsumption(double liters) async {
    DateTime now = DateTime.now();
    await _getConsumptionReference(now).set({"consumption": liters});
  }

  Future<double?> fetchDailyWaterConsumption(DateTime date) async {
    DataSnapshot dataSnapshot = await _getConsumptionReference(date)
        .once()
        .then((event) => event.snapshot);

    if (dataSnapshot.value != null) {
      Map<String, dynamic> data = dataSnapshot.value as Map<String, dynamic>;
      return data['consumption']?.toDouble();
    }
    return null;
  }

  Future<Map<String, double>> fetchHourlyWaterConsumptionData(
      DateTime date) async {
    DataSnapshot dataSnapshot = await _getConsumptionReference(date)
        .once()
        .then((event) => event.snapshot);

    if (dataSnapshot.value != null) {
      Map<String, dynamic> data = dataSnapshot.value as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, value.toDouble()));
    }
    return {};
  }

  Future<Map<String, double>> fetchWeeklyWaterConsumptionData(
      DateTime date) async {
    DataSnapshot dataSnapshot = await _getMonthReference(date.year, date.month)
        .once()
        .then((event) => event.snapshot);

    Map<String, double> weeklyData = {};

    if (dataSnapshot.value != null) {
      Map<String, dynamic> monthData =
          dataSnapshot.value as Map<String, dynamic>;

      for (int i = 1; i <= 5; i++) {
        weeklyData['Week $i'] = 0.0;
      }

      monthData.forEach((dayKey, dayData) {
        DateTime day = DateTime(date.year, date.month, int.parse(dayKey));
        int weekNumber = getWeekOfMonth(day);

        // Safely get the consumption value
        double consumption = dayData['consumption']?.toDouble() ?? 0.0;
        // Safely add the consumption to the weekly total
        weeklyData['Week $weekNumber'] =
            (weeklyData['Week $weekNumber'] ?? 0.0) + consumption;
      });
    }

    return weeklyData;
  }

  int getWeekOfMonth(DateTime date) {
    int firstDayOfMonth = DateTime(date.year, date.month, 1).weekday;
    int dayOfMonth = date.day;
    int weekNumber = ((dayOfMonth + firstDayOfMonth - 1) / 7).ceil();
    return weekNumber;
  }
}
