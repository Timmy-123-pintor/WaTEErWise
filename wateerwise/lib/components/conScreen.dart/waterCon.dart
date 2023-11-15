// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../constant.dart';

class WaterConsumption extends StatefulWidget {
  final String userEmail;

  const WaterConsumption({Key? key, required this.userEmail}) : super(key: key);

  @override
  _WaterConsumptionState createState() => _WaterConsumptionState();
}

class _WaterConsumptionState extends State<WaterConsumption> {
  late String apiUrl;
  double totalLiters = 0.0;

  @override
  void initState() {
    super.initState();
    apiUrl =
        'http://localhost:3000/api/sensor/${widget.userEmail}/sensor1/totalLiters';
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      String apiUrl =
          'http://localhost:3000/api/sensor/${widget.userEmail}/sensor1/totalLiters';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          // Check if the data is in the expected format
          if (data.containsKey('totalLiters')) {
            setState(() {
              totalLiters = data['totalLiters'];
            });
          } else {
            if (kDebugMode) {
              print('Error: Unexpected data format');
            }
          }
        } else {
          if (kDebugMode) {
            print('Error: Unexpected response format');
          }
        }
      } else {
        if (kDebugMode) {
          print('Error: ${response.reasonPhrase}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: tWhite,
                image: const DecorationImage(
                  image: AssetImage('assets/GIF/waterdrop.gif'),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$totalLiters Liters', // Display the totalLiters value
                    style: GoogleFonts.quicksand(
                      textStyle: conText1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Current Water Consumption',
                    style: GoogleFonts.quicksand(
                      textStyle: conText2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
