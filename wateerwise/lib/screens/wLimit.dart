import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/components/Graphs/WLimitGraph/wLimitGraph.dart';
import 'package:wateerwise/components/WaterLimit/waterLimitCon.dart';
import 'package:wateerwise/provider/provider.dart';
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
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Center(
                          child: SemiCircleProgressBar(
                            maxValue: progressProvider.maxValue,
                          ),
                        ),
                        // const InputTextField(),
                      ],
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
