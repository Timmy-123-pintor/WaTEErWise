import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wateerwise/services/firebase_service.dart';

class WaterConsumptionHistory extends StatelessWidget {
  final DatabaseReference databaseReference;

  const WaterConsumptionHistory._(this.databaseReference, {Key? key})
      : super(key: key);

  factory WaterConsumptionHistory() {
    final firebaseService = FirebaseService();
    final databaseReference = firebaseService.mainReference
        .child("waterConsumption")
        .child(firebaseService.currentUserUid);
    return WaterConsumptionHistory._(databaseReference);
  }

  Stream<DataSnapshot> getHistoryStream() {
    return databaseReference.onValue
        .map((event) => event.snapshot)
        .handleError((error, stackTrace) {
      if (kDebugMode) {
        print("Error in stream: $error");
      }
      return Stream.error(
          "Failed to fetch water consumption history due to: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DataSnapshot>(
      stream: getHistoryStream(),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          if (kDebugMode) {
            print("StreamBuilder Error: ${snapshot.error}");
          }
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.hasData && snapshot.data!.value is Map) {
          Map<dynamic, dynamic> years =
              snapshot.data!.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> allData = [];

          years.forEach((year, months) {
            (months as Map<dynamic, dynamic>).forEach((month, days) {
              (days as Map<dynamic, dynamic>).forEach((day, data) {
                allData.add({
                  'date': '$day-$month-$year',
                  'consumption': data['consumption']
                });
              });
            });
          });

          const double THRESHOLD = 5000;

          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Text(
                  "Water Consumption",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date"),
                      Text("Water Consumption"),
                      Text("Status"),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: allData.length,
                    itemBuilder: (context, index) {
                      var date = allData[index]['date'];
                      var consumption = allData[index]['consumption'];
                      bool highConsumption = consumption > THRESHOLD;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("$date"),
                            Text("${consumption}m3"),
                            Icon(
                              highConsumption
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color:
                                  highConsumption ? Colors.red : Colors.green,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(
            child: Text("No water consumption history available."));
      },
    );
  }
}
