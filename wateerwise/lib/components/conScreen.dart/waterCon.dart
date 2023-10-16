// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wateerwise/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constant.dart';

class WaterConsumption extends StatefulWidget {
  const WaterConsumption({Key? key}) : super(key: key);

  @override
  _WaterConsumptionState createState() => _WaterConsumptionState();
}

class _WaterConsumptionState extends State<WaterConsumption> {
  DatabaseReference? databaseReference;

  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    databaseReference = FirebaseService()
        .mainReference
        .child("users/$uid/waterflow/totalLiters");
  }

  Stream<DataSnapshot> getFlowRateStream() {
    if (databaseReference != null) {
      return databaseReference!.onValue.map((event) => event.snapshot);
    } else {
      return const Stream<
          DataSnapshot>.empty(); // Return an empty stream if databaseReference is null
    }
  }

  Future<void> _reloadData() async {
    if (databaseReference != null) {
      await databaseReference!.once();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RefreshIndicator(
          onRefresh: _reloadData,
          child: StreamBuilder<DataSnapshot>(
            stream: getFlowRateStream(),
            builder:
                (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                if (kDebugMode) {
                  print("StreamBuilder Error: ${snapshot.error}");
                }
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              var snapValue = snapshot.data?.value; // Use ?. for null safety
              Widget content;

              if (snapValue == null) {
                content = const Text("No data available");
              } else if (snapValue is double || snapValue is int) {
                content = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$snapValue',
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
              return Stack(
                children: [
                  Container(
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
                  ),
                  Positioned(
                    top: 10, // adjust as needed
                    right: 10, // adjust as needed
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _reloadData,
                      color:
                          tBlue, // or any color that contrasts with your background
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
