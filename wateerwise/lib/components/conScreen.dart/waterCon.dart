// ignore_for_file: file_names, deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../constant.dart';

class WaterConsumption extends StatefulWidget {
  const WaterConsumption({Key? key}) : super(key: key);

  @override
  _WaterConsumptionState createState() => _WaterConsumptionState();
}

class _WaterConsumptionState extends State<WaterConsumption> {
  late DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    final firebaseApp = Firebase.app();
    databaseReference = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL:
          'https://waterwise-database-default-rtdb.asia-southeast1.firebasedatabase.app/',
    ).ref();
  }

  Stream<DataSnapshot> getFlowRateStream() {
    return databaseReference
        .child("waterflow/totalLiters")
        .onValue
        .map((event) => event.snapshot);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<DataSnapshot>(
          stream: getFlowRateStream(),
          builder:
              (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              var snapValue = snapshot.data!.value;
              if (snapValue == null) {
                return const Text("No data available"); // Handle null values
              } else if (snapValue is double || snapValue is int) {
                return Text(
                  "${snapValue.toString()} cubic meters",
                  style: GoogleFonts.quicksand(
                    textStyle: conText1,
                  ),
                );
              }
              return Text(
                  "Unexpected data type: $snapValue"); // Handle unexpected types
            } else if (snapshot.hasError) {
              return Text(
                "Error: ${snapshot.error.toString()}",
                style: GoogleFonts.quicksand(
                  textStyle: conText1,
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        Text(
          'Current Water Consumption',
          style: GoogleFonts.quicksand(
            textStyle: conText2,
          ),
        ),
      ],
    );
  }
}
