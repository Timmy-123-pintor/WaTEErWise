// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';

class ProfilePick extends StatelessWidget {
  const ProfilePick({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
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
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: tWhite,
                    ),
                    color: tGray,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: tWhite,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Melvin P. Forbis",
            style: GoogleFonts.quicksand(
              textStyle: name,
            ),
          ),
          Text(
            "Account No. 202300010",
            style: GoogleFonts.quicksand(
              textStyle: accId,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 130,
            height: 30,
            decoration: const BoxDecoration(
              color: tOrangeO,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                " • Restticted",
                style: GoogleFonts.inter(
                  textStyle: status,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "Peak Water Consumption and Billing",
                style: GoogleFonts.quicksand(
                  textStyle: profileText,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 100,
                height: 30,
                decoration: const BoxDecoration(
                  color: tBlueO,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    "January 2023",
                    style: GoogleFonts.inter(
                      textStyle: profileRow,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: 100,
                height: 30,
                decoration: const BoxDecoration(
                  color: tBlueO,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    "62 m3",
                    style: GoogleFonts.inter(
                      textStyle: profileRow,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: 100,
                height: 30,
                decoration: const BoxDecoration(
                  color: tBlueO,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    "P 1860",
                    style: GoogleFonts.inter(
                      textStyle: profileRow,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 29),
            child: Row(
              children: [
                Text(
                  "Month",
                  style: GoogleFonts.quicksand(
                    textStyle: profileText,
                  ),
                ),
                const SizedBox(
                  width: 35,
                ),
                Text(
                  "Water Consumption",
                  style: GoogleFonts.quicksand(
                    textStyle: profileText,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  "Bill Amount",
                  style: GoogleFonts.quicksand(
                    textStyle: profileText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
