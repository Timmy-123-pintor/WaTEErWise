// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constant.dart';

class PaymentGraph extends StatelessWidget {
  const PaymentGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 180,
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
              width: 5,
            ),
            Text(
              'June 2025',
              style: GoogleFonts.quicksand(
                textStyle: conText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
