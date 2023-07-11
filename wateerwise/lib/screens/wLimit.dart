import 'package:flutter/material.dart';

import '../components/Graphs/HomeGraphs/consumptionGraph.dart';
import '../components/Graphs/WLimitGraph/wLimitGraph.dart';
import '../components/WaterLimit/waterCon.dart';
import '../constant.dart';

class WLimit extends StatefulWidget {
  const WLimit({super.key});

  @override
  State<WLimit> createState() => _WLimitState();
}

class _WLimitState extends State<WLimit> {
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
                color: tWG,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ListView(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    WLimitGraph(),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: WaterCon(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConsumptionTrend(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
