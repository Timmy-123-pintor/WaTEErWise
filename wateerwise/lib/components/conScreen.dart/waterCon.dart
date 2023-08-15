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
              Widget content;

              if (snapValue == null) {
                content = const Text("No data available");
              } else if (snapValue is double || snapValue is int) {
                double displayValue;

                if (snapValue is double) {
                  displayValue = snapValue;
                } else {
                  displayValue = (snapValue as int).toDouble();
                }

                double cubicMetersValue =
                    displayValue / 1000;

                content = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${cubicMetersValue.toStringAsFixed(3)} cubic meters",
                      style: GoogleFonts.quicksand(
                        textStyle: conText1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Current Water Consumption',
                      style: GoogleFonts.quicksand(
                        textStyle: conText2,
                      ),
                    ),
                  ],
                );
              } else {
                content = Text("Unexpected data type: $snapValue");
              }

              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: tWhite,
                  image: const DecorationImage(
                    image: AssetImage('assets/GIF/waterdrop.gif'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: content,
              );
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
      ],
    );
  }
}
