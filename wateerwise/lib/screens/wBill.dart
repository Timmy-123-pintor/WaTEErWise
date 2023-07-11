import 'package:flutter/material.dart';
import '../components/WaterBill/billSumary.dart';
import '../constant.dart';

class WBill extends StatefulWidget {
  const WBill({super.key});

  @override
  State<WBill> createState() => _WBillState();
}

class _WBillState extends State<WBill> {
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
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: const [
                    BillSum(),

                    // ConsumptionTrend(),
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
