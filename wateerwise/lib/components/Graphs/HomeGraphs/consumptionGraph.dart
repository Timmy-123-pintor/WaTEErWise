<<<<<<< Updated upstream
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/components/Graphs/HomeGraphs/waterPoint.dart';
=======
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
>>>>>>> Stashed changes

import '../../../constant.dart';

class ConsumptionTrend extends StatelessWidget {
<<<<<<< Updated upstream
  final List<WaterPoint> points;
  const ConsumptionTrend(this.points, {super.key});
=======
  const ConsumptionTrend({super.key});
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
<<<<<<< Updated upstream
      height: 220,
=======
      height: 180,
>>>>>>> Stashed changes
      decoration: BoxDecoration(
        color: tWhite,
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
<<<<<<< Updated upstream
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "Water Consumption Trend",
              style: GoogleFonts.quicksand(
                textStyle: conText2,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AspectRatio(
            aspectRatio: 2,
            child: LineChart(LineChartData(lineBarsData: [
              LineChartBarData(
                  spots:
                      points.map((point) => FlSpot(point.x, point.y)).toList(),
                  isCurved: true,
                  dotData: const FlDotData(show: true))
            ])),
          ),
        ],
=======
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              'Graph',
              style: GoogleFonts.quicksand(
                textStyle: conText1,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'June 2025',
              style: GoogleFonts.quicksand(
                textStyle: conText1,
              ),
            ),
          ],
        ),
>>>>>>> Stashed changes
      ),
    );
  }
}
<<<<<<< Updated upstream

// ignore_for_file: file_names
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:waterwise/constant.dart';

// class ConsumptionTrend extends StatelessWidget {
//   const ConsumptionTrend({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 350,
//       height: 180,
//       decoration: BoxDecoration(
//         color: tWhite,
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
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Row(
//           children: [
//             Text(
//               'Graph',
//               style: GoogleFonts.quicksand(
//                 textStyle: conText1,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             Text(
//               'June 2025',
//               style: GoogleFonts.quicksand(
//                 textStyle: conText1,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
=======
>>>>>>> Stashed changes
