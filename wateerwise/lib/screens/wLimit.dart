import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/components/Graphs/HomeGraphs/waterConsumptionHistory.dart';
import 'package:wateerwise/components/WaterLimit/waterLimitCon.dart';
import 'package:wateerwise/provider/provider.dart';
import '../components/Graphs/WLimitGraph/wLimitGraph.dart';
import '../constant.dart';

class WLimit extends StatefulWidget {
  const WLimit({super.key});

  @override
  State<WLimit> createState() => _WLimitState();
}

class _WLimitState extends State<WLimit> {
  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
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
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: [
                    Stack(
                      alignment:
                          Alignment.center, // Center the SemiCircleProgressBar
                      children: [
                        SemiCircleProgressBar(
                          maxValue: progressProvider.maxValue,
                        ),
                        const Positioned(
                          top:
                              210, // Adjust this value for vertical positioning
                          child: InputTextField(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    WaterConsumptionHistory(),
                    const SizedBox(
                      height: 10,
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
