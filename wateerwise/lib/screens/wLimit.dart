import 'package:flutter/material.dart';
import 'package:wateerwise/components/Graphs/HomeGraphs/waterPoint.dart';

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
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const WLimitGraph(
                      endValue: 0,
                      currentValue: 0,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: WaterCon(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ConsumptionTrend(waterPoints),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 350,
                      height: 235,
                      decoration: BoxDecoration(
                        color: tWhite,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/conHistory.png'),
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
                    ),
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
