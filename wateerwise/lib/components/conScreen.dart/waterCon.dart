// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wateerwise/provider/provider.dart';

import '../../constant.dart';

class WaterConsumption extends StatefulWidget {
  final String userEmail;

  const WaterConsumption({Key? key, required this.userEmail}) : super(key: key);

  @override
  _WaterConsumptionState createState() => _WaterConsumptionState();
}

class _WaterConsumptionState extends State<WaterConsumption> {
  late String apiUrl;
  String sensorId = "";

  @override
  void initState() {
    super.initState();
    fetchSensorId();
  }

  Future<void> fetchSensorId() async {
    String url = 'http://localhost:3000/api/getSensorId/${widget.userEmail}';
    Map<String, dynamic> data =
        await Provider.of<WaterConsumptionProvider>(context, listen: false)
            .fetchData(url);

    if (data.containsKey('sensorId')) {
      setState(() {
        sensorId = data['sensorId'];
      });
      fetchSensorData();
    } else {
      if (kDebugMode) {
        print('Error: Unexpected response format');
      }
    }
  }

  Future<void> fetchSensorData() async {
    Provider.of<WaterConsumptionProvider>(context, listen: false)
        .fetchSensorData(widget.userEmail, sensorId);
  }

  @override
  Widget build(BuildContext context) {
    final totalLiters =
        Provider.of<WaterConsumptionProvider>(context).totalLiters;
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
