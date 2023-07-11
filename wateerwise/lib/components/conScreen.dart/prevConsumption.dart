import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';

class PrevComCon extends StatelessWidget {
  const PrevComCon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 100,
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
      child: Column(
        children: [
          Text(
            '26',
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
            'Previous Water Consumption\n        Reading (Last Month)',
            style: GoogleFonts.quicksand(
              textStyle: conText2,
            ),
          ),
        ],
      ),
    );
  }
}
