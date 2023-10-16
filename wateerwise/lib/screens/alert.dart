// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Components/Alert/latest.dart';
import '../constant.dart';

class Alert extends StatelessWidget {
  const Alert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBlue,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: alertC,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Latest",
                      style: GoogleFonts.quicksand(
                        textStyle: latest,
                      ),
                    ),
                  ),
                  const Latest()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//Things to do to make this screen function;

//Make dummy data
//Set data for the dummy
//Test the dummy data
//Test if the notification screen function

