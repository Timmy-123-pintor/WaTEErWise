import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/constant.dart';
import 'package:wateerwise/services/firebase_database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:wateerwise/services/firebase_service.dart';
import 'package:wateerwise/widgets/consumption_chart.dart';

enum GraphView { day, week, month }

class ConsumptionTrend extends StatefulWidget {
  const ConsumptionTrend({Key? key}) : super(key: key);

  @override
  State<ConsumptionTrend> createState() => _ConsumptionTrendState();
}

class _ConsumptionTrendState extends State<ConsumptionTrend> {
  late Stream<List<FlSpot>> dataStream;
  GraphView currentView = GraphView.month;
  GraphView? _selectedView = GraphView.month; // Default to Month view
  DateTime currentDate = DateTime.now(); // Current date
  bool showAvg = false;
  List<String> months = [
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

  int currentStartIndex = 0;
  int currentMonthIndex = 0;
  int currentYear = DateTime.now().year;
  List<FlSpot> consumptionData = [];

  @override
  void initState() {
    super.initState();
    dataStream = fetchData() as Stream<List<FlSpot>>;
  }

  List<FlSpot> createSpotsForDayView(Map<String, double> data) {
    return data.entries
        .map((entry) => FlSpot(
              double.parse(entry.key),
              entry.value,
            ))
        .toList();
  }

  List<FlSpot> createSpotsForMonthView(Map<String, double> data) {
    return data.entries
        .map((entry) => FlSpot(
              double.parse(entry.key), // Week of the month (1-4/5)
              entry.value, // Water consumption
            ))
        .toList();
  }

  List<FlSpot> createSpotsForWeekView(Map<String, double> data) {
    return data.entries
        .map((entry) => FlSpot(
              double.parse(entry.key), // Day of the week (1-7)
              entry.value, // Water consumption
            ))
        .toList();
  }

  Future<List<FlSpot>> fetchData() async {
    FirebaseDatabaseMethods firebaseMethods = FirebaseDatabaseMethods(
      FirebaseAuth.instance,
      FirebaseService().mainReference,
    );

    Map<String, double> dataMap;
    switch (currentView) {
      case GraphView.day:
        dataMap =
            await firebaseMethods.fetchHourlyWaterConsumptionData(currentDate);
        return createSpotsForDayView(dataMap);

      case GraphView.week:
        dataMap =
            await firebaseMethods.fetchWeeklyWaterConsumptionData(currentDate);
        return createSpotsForWeekView(dataMap);

      case GraphView.month:
        dataMap =
            await firebaseMethods.fetchWeeklyWaterConsumptionData(currentDate);
        return createSpotsForMonthView(dataMap);

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: tWhite,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoSegmentedControl<GraphView>(
              groupValue: _selectedView,
              children: const {
                GraphView.day: Text("Day"),
                GraphView.week: Text("Week"),
                GraphView.month: Text("Month"),
              },
              onValueChanged: (GraphView newValue) {
                setState(() {
                  _selectedView = newValue;
                  dataStream = fetchData() as Stream<List<FlSpot>>;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Water Consumption Trend",
                    style: GoogleFonts.quicksand(
                      textStyle: conText2,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.chevron_left, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            if (currentStartIndex > 0) {
                              currentStartIndex -=
                                  5; // Navigate back by 5 dates
                            }
                            fetchData();
                          });
                        },
                      ),
                      Text(
                        currentView == GraphView.day
                            ? "${currentDate.day} ${months[currentDate.month - 1]}, $currentYear"
                            : currentView == GraphView.month
                                ? "${months[currentDate.month - 1]} $currentYear"
                                : "$currentYear",
                        style: const TextStyle(color: tBlue),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.chevron_right, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            if (currentStartIndex + 5 <
                                consumptionData.length) {
                              currentStartIndex +=
                                  5; // Navigate forward by 5 dates
                            }
                            fetchData();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StreamBuilder<List<FlSpot>>(
              // Changed type to List<FlSpot>
              stream: dataStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // If data is available, use it. Otherwise, use an empty list
                  List<FlSpot> data = snapshot.data ?? [];

                  return Stack(
                    children: <Widget>[
                      ConsumptionChart(
                        consumptionData: data,
                        showAvg: showAvg,
                        currentView: currentView,
                        currentStartIndex: currentStartIndex,
                        currentDate: currentDate,
                        months: months,
                      ),
                      SizedBox(
                        width: 60,
                        height: 34,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              showAvg = !showAvg;
                            });
                          },
                          child: Text(
                            'avg',
                            style: TextStyle(
                              fontSize: 12,
                              color: showAvg
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
