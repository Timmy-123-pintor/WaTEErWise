// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wateerwise/constant.dart';

class SemiCircleProgressBar extends StatefulWidget {
  final double maxValue;

  const SemiCircleProgressBar({
    Key? key,
    required this.maxValue,
  }) : super(key: key);

  @override
  State<SemiCircleProgressBar> createState() => _SemiCircleProgressBarState();
}

class _SemiCircleProgressBarState extends State<SemiCircleProgressBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: widget.maxValue,
              startAngle: 180,
              endAngle: 0,
              showLastLabel: true,
              showLabels: true,
              showTicks: false,
              interval: 500,
              axisLineStyle: AxisLineStyle(
                thickness: 35,
                color: Colors.grey[300], // Background color
                thicknessUnit: GaugeSizeUnit.logicalPixel,
              ),
              pointers: const <GaugePointer>[
                RangePointer(
                  value: 0, // Set the current progress value here
                  cornerStyle: CornerStyle.bothCurve,
                  width: 20, // Adjust the width of the progress bar
                  sizeUnit: GaugeSizeUnit.logicalPixel,
                  color: tBlue, // Progress bar color
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
