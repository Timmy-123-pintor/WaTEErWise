import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/constant.dart';
import 'package:wateerwise/services/firebase_database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:wateerwise/services/firebase_service.dart';
import 'package:wateerwise/widgets/consumption_chart.dart';

enum GraphView { day, month, year }

class ConsumptionTrend extends StatefulWidget {
  const ConsumptionTrend({super.key});

  @override
  State<ConsumptionTrend> createState() => _ConsumptionTrend();
}

class _ConsumptionTrend extends State<ConsumptionTrend> {
  late Stream<List<double>> dataStream;
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
  List<double> consumptionData = [];

  @override
  void initState() {
    super.initState();
    dataStream = fetchData();
  }

  Stream<List<double>> fetchData() {
    FirebaseDatabaseMethods firebaseMethods = FirebaseDatabaseMethods(
      FirebaseAuth.instance,
      FirebaseService().mainReference,
    );

    switch (currentView) {
      case GraphView.day:
        // Convert the Future<double?> to Stream<List<double>>
        return Stream.fromFuture(
                firebaseMethods.fetchDailyWaterConsumption(currentDate))
            .map((dailyData) => [dailyData ?? 0.0]);

      case GraphView.month:
        return firebaseMethods.waterConsumptionDataStream(
            currentYear, currentDate.month);

      case GraphView.year:
        // You would need to handle the year view. I noticed you had logic
        // previously that fetched the average for each month. You can use a
        // similar approach but instead of using async/await,
        // you'd work with streams.
        // For now, I'm returning an empty stream.
        return const Stream.empty();

      default:
        return const Stream.empty();
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
                GraphView.month: Text("Month"),
                GraphView.year: Text("Year"),
              },
              onValueChanged: (GraphView newValue) {
                setState(() {
                  _selectedView = newValue;
                  dataStream = fetchData();
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
            StreamBuilder<List<double>>(
              stream: dataStream, // Use the initialized stream
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // If data is available, use it. Otherwise, use an empty list
                  List<double> data = snapshot.data ?? [];

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
