import 'package:flutter/material.dart';
import '../components/HomeGraphs/consumptionGraph.dart';
import '../components/HomeGraphs/paymentGraph.dart';
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
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    WaterConsumption(),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
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
                    SizedBox(
                      height: 20,
                    ),
                    ConsumptionTrend(),
                    SizedBox(
                      height: 20,
                    ),
                    PaymentGraph(),
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
