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

  Stream<List<double>> waterConsumptionDataStream(int year, int month) {
    return _getMonthReference(year, month).onValue.map((event) {
      List<double> consumptionData = [];
      if (event.snapshot.value != null) {
        Map<String, dynamic> monthData =
            event.snapshot.value as Map<String, dynamic>;
        for (var dayData in monthData.values) {
          if (dayData['consumption'] != null) {
            consumptionData.add(dayData['consumption'].toDouble());
          }
        }
      }
      return consumptionData;
    });
  }

  Future<double?> fetchDailyWaterConsumption(DateTime date) async {
    DataSnapshot dataSnapshot = await _getConsumptionReference(date)
        .onValue
        .first
        .then((event) => event.snapshot);

    if (dataSnapshot.value != null) {
      Map<String, dynamic> data = dataSnapshot.value as Map<String, dynamic>;
      return data['consumption']?.toDouble();
    }
    return null;
  }

  Future<double> fetchMonthlyWaterConsumption(int year, int month) async {
    List<double> monthlyData =
        await waterConsumptionDataStream(year, month).first;
    return monthlyData.isNotEmpty ? monthlyData.reduce((a, b) => a + b) : 0.0;
  }

  Future<double> fetchPreviousMonthWaterConsumption() async {
    DateTime now = DateTime.now();
    DateTime lastMonth = (now.month == 1)
        ? DateTime(now.year - 1, 12, now.day)
        : DateTime(now.year, now.month - 1, now.day);

    return await fetchMonthlyWaterConsumption(lastMonth.year, lastMonth.month);
  }

  Future<List<double>> fetchYearlyAverageWaterConsumption(int year) async {
    List<double> yearlyData = [];
    for (int i = 0; i < 12; i++) {
      double total = await fetchMonthlyWaterConsumption(year, i + 1);
      double daysInMonth = DateTime(year, i + 2, 0).day as double;
      double monthlyAverage = total / daysInMonth;
      yearlyData.add(monthlyAverage);
    }
    return yearlyData;
  }
}
