import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';

class BillSum extends StatelessWidget {
  const BillSum({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 235,
      width: double.infinity,
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
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Billing Summary",
                  style: GoogleFonts.quicksand(
                    textStyle: conText2,
                  ),
                ),
                const SizedBox(
                  width: 200,
                ),
                Container(
                  width: 50,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: tGray,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      " • Paid",
                      style: GoogleFonts.inter(
                        textStyle: paid,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  "Billing Period",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "April 29, 2023 - May 28, 2023",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Billing Period",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  "April 29, 2023 - May 28, 2023",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Billing Period",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  "April 29, 2023 - May 28, 2023",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Billing Period",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  "April 29, 2023 - May 28, 2023",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Billing Period",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  "April 29, 2023 - May 28, 2023",
                  style: GoogleFonts.quicksand(
                    textStyle: conTextBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 220,
                ),
                Text(
                  "Show Previous Billing",
                  style: GoogleFonts.quicksand(textStyle: conText2),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
