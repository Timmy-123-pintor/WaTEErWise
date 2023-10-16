import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/services/firebase_database_methods.dart';
import 'package:wateerwise/services/firebase_service.dart';

import '../../constant.dart';

class PrevComCon extends StatefulWidget {
  const PrevComCon({Key? key}) : super(key: key);

  @override
  _PrevComConState createState() => _PrevComConState();
}

class _PrevComConState extends State<PrevComCon> {
  double? yesterdayConsumption;

  @override
  void initState() {
    super.initState();
    fetchYesterdayData();
  }

  Future<void> fetchYesterdayData() async {
    final _dbMethods = FirebaseDatabaseMethods(
      FirebaseAuth.instance,
      FirebaseService().mainReference,
    );

    // Calculate yesterday's date
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));

    double? fetchedData =
        await _dbMethods.fetchDailyWaterConsumption(yesterday);

    setState(() {
      yesterdayConsumption = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
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
        children: [
          Text(
            '${yesterdayConsumption ?? 0}',
            style: GoogleFonts.quicksand(
              textStyle: conText1,
            ),
          ),
          Text(
            'Cubic meters',
            style: GoogleFonts.quicksand(
              textStyle: conText2,
            ),
          ),
          Text(
            '    Yesterday\'s Water\nConsumption Reading',
            style: GoogleFonts.quicksand(
              textStyle: conText2,
            ),
          ),
        ],
      ),
    );
  }
}
