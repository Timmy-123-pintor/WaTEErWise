import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/services/firebase_database_methods.dart';
import 'package:wateerwise/services/firebase_service.dart';

import '../../constant.dart';

class CurrentBill extends StatefulWidget {
  const CurrentBill({Key? key}) : super(key: key);

  @override
  _CurrentBillState createState() => _CurrentBillState();
}

class _CurrentBillState extends State<CurrentBill> {
  final _dbMethods = FirebaseDatabaseMethods(
    FirebaseAuth.instance,
    FirebaseService().mainReference,
  );

  Stream<double?> getDailyConsumptionStream() {
    DateTime now = DateTime.now();
    return _dbMethods.fetchDailyWaterConsumption(now).asStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double?>(
      stream: getDailyConsumptionStream(),
      builder: (BuildContext context, AsyncSnapshot<double?> snapshot) {
        String displayText = "0";
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            displayText = "${snapshot.data!.toStringAsFixed(2)} liters";
          } else if (snapshot.hasError) {
            displayText = "Error: ${snapshot.error}";
          } else {
            displayText = "No data for today";
          }
        }

        return Container(
          height: 95,
          decoration: BoxDecoration(
            color: tWhite,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayText,
                style: GoogleFonts.quicksand(
                  textStyle: conText1,
                ),
              ),
              Text(
                'Daily Water Consumption',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: conText2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
