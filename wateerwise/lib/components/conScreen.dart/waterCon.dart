// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';

class WaterConsumption extends StatelessWidget {
  const WaterConsumption({super.key});

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
          Text(
            '30 cubic meters',
            style: GoogleFonts.quicksand(
              textStyle: conText1,
            ),
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
