// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.quicksand(
            textStyle: appBar,
          ),
        ),
        backgroundColor: tBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text(
                "About",
                style: GoogleFonts.quicksand(
                  textStyle: waterInCub,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'WaterWise+',
                style: GoogleFonts.quicksand(
                  textStyle: waterStyleB,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Container(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: tBlue,
                  ),
                  shape: BoxShape.circle,
                  color: tBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
