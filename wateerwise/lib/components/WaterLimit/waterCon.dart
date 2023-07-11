import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import 'dropBox.dart';

class WaterCon extends StatelessWidget {
  const WaterCon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 46,
              width: 213,
              decoration: BoxDecoration(
                color: tWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  Text(
                    "95",
                    style: GoogleFonts.quicksand(
                      textStyle: conNum,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Water Consumption",
                    style: GoogleFonts.quicksand(
                      textStyle: conText2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownContainer(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tBlue,
                tBlueG,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "Water Consumption Limit",
              style: GoogleFonts.quicksand(
                textStyle: gradCon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
