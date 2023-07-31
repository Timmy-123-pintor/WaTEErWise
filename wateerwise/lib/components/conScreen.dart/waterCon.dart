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
  final databaseReference = FirebaseDatabase.instance.reference();

  Stream<DataSnapshot> getFlowRateStream() {
    return databaseReference
        .child("totalLiters")
        .onValue
        .map((event) => event.snapshot);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: tWhite,
        image: const DecorationImage(
          image: AssetImage('assets/GIF/waterdrop.gif'),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          StreamBuilder<DataSnapshot>(
            stream: getFlowRateStream(),
            builder:
                (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data?.value != null) {
                var snapValue = snapshot.data!.value;
                if (snapValue is double) {
                  return Text(
                    "${snapValue.toString()} cubic meters",
                    style: GoogleFonts.quicksand(
                      textStyle: conText1,
                    ),
                  );
                } else if (snapValue is int) {
                  return Text(
                    "${snapValue.toDouble().toString()} cubic meters",
                    style: GoogleFonts.quicksand(
                      textStyle: conText1,
                    ),
                  );
                }
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
      ),
    );
  }
}

// // ignore_for_file: file_names
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../../constant.dart';

// class WaterConsumption extends StatefulWidget {
//   const WaterConsumption({super.key});

//   @override
//   State<WaterConsumption> createState() => _WaterConsumptionState();
// }

// class _WaterConsumptionState extends State<WaterConsumption> {
//   final databaseReference = FirebaseDatabase.instance.reference();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.8,
//       height: MediaQuery.of(context).size.height * 0.1,
//       decoration: BoxDecoration(
//         color: tWhite,
//         image: const DecorationImage(
//           image: AssetImage('assets/GIF/waterdrop.gif'),
//           fit: BoxFit.cover,
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(10),
//           bottomRight: Radius.circular(10),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5), // Shadow color
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           StreamBuilder<DatabaseEvent>(
//             stream: databaseReference.child("totalLiters").onValue,
//             builder:
//                 (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
//               if (snapshot.hasError) {
//                 if (kDebugMode) {
//                   print('Error: ${snapshot.error}');
//                 }
//                 return Center(
//                   child: Text(
//                     'Error: ${snapshot.error}',
//                     style: GoogleFonts.quicksand(
//                       textStyle: error,
//                     ),
//                   ),
//                 );
//               }
//               if (snapshot.hasData) {
//                 double flowRate =
//                     double.parse(snapshot.data!.snapshot.value.toString());
//                 return Text(
//                   "$flowRate cubic meters",
//                   style: GoogleFonts.quicksand(
//                     textStyle: conText1,
//                   ),
//                 );
//               }
//               return const CircularProgressIndicator();
//             },
//           ),
//           Text(
//             'Current Water Consumption',
//             style: GoogleFonts.quicksand(
//               textStyle: conText2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
