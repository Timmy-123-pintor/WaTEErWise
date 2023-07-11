import 'package:flutter/material.dart';
import '../components/Graphs/HomeGraphs/billPoint.dart';
import '../components/Graphs/HomeGraphs/consumptionGraph.dart';
import '../components/Graphs/HomeGraphs/paymentGraph.dart';
import '../components/Graphs/HomeGraphs/waterPoint.dart';
import '../components/conScreen.dart/currentBill.dart';
import '../components/conScreen.dart/prevConsumption.dart';
import '../components/conScreen.dart/waterCon.dart';
import '../constant.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
                    const WaterConsumption(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Row(
                        children: [
                          PrevComCon(),
                          SizedBox(
                            width: 10,
                          ),
                          CurrentBill(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConsumptionTrend(waterPoints),
                    const SizedBox(
                      height: 20,
                    ),
                    PaymentGraph(billPoints),
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
