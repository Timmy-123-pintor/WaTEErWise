import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/components/Graphs/WLimitGraph/wLimitGraph.dart';
import '../../constant.dart';
import 'dropBox.dart';

class WaterCon extends StatefulWidget {
  const WaterCon({Key? key}) : super(key: key);

  @override
  _WaterConState createState() => _WaterConState();
}

class _WaterConState extends State<WaterCon> {
  final TextEditingController _controller = TextEditingController();
  double? consumptionLimit;
  String currentTrackingPeriod = 'Select Period';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WLimitGraph(
          endValue: (consumptionLimit ?? 0) > 0
              ? consumptionLimit!
              : 100, 
          currentValue: double.tryParse(_controller.text) ?? 0,
        ),
        Text(
          "Water Consumption Limit",
          style: GoogleFonts.quicksand(
            textStyle: conText2,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: tWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.quicksand(textStyle: conNum),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          setState(() {
                            consumptionLimit = double.tryParse(value);
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: DropdownContainer(
                onPeriodSelected: (selectedPeriod) {
                  setState(() {
                    currentTrackingPeriod = selectedPeriod;
                  });
                  if (kDebugMode) {
                    print("Selected tracking period: $currentTrackingPeriod");
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
