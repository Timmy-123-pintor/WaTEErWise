// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wateerwise/constant.dart';
import 'package:wateerwise/provider/provider.dart';

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
  final TextEditingController _controller = TextEditingController();
  bool _hasError = false;
  String selectedValue = 'Option 1';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput() {
    final progressProvier =
        Provider.of<ProgressProvider>(context, listen: false);

    if (_controller.text.isEmpty) {
      setState(() {
        _hasError = true;
      });
    } else {
      setState(() {
        _hasError = false;
      });
      final newValue = double.tryParse(_controller.text);
      if (newValue != null) {
        progressProvier.setMaxValue(newValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: widget
                  .maxValue, // Use the maximum value passed from the constructor
              startAngle: 180,
              endAngle: 0,
              showLastLabel: true,
              showLabels: true,
              showTicks: false,
              interval: 500,
              axisLineStyle: AxisLineStyle(
                thickness: 20, // Adjust the thickness of the semi-circle
                color: Colors.grey[300], // Background color
                thicknessUnit: GaugeSizeUnit.logicalPixel,
              ),
              pointers: const <GaugePointer>[
                RangePointer(
                  value: 0, // Set the current progress value here
                  cornerStyle: CornerStyle.bothCurve,
                  width: 20, // Adjust the width of the progress bar
                  sizeUnit: GaugeSizeUnit.logicalPixel,
                  color: Colors.blue, // Progress bar color
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 40,
              width: 160,
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
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter Value',
                  errorText:
                      _hasError ? 'Please input your desired limit' : null,
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), // Allow only digits
                ],
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            //Drop downbox
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: tWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Center(
                child: DropdownButton<String>(
                  value: selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  underline: Container(), // or SizedBox.shrink()
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Option 1',
                      child: Text(
                        'Option 1',
                        style: GoogleFonts.quicksand(
                            textStyle: navText,
                            color:
                                selectedValue == 'Option 1' ? tBlue : tBlack),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Option 2',
                      child: Text(
                        'Option 2',
                        style: GoogleFonts.quicksand(
                            textStyle: navText,
                            color:
                                selectedValue == 'Option 2' ? tBlue : tBlack),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Option 3',
                      child: Text(
                        'Option 3',
                        style: GoogleFonts.quicksand(
                            textStyle: navText,
                            color:
                                selectedValue == 'Option 3' ? tBlue : tBlack),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // TextButton(
        //   onPressed: _validateInput,
        //   style: ButtonStyle(
        //     backgroundColor: MaterialStateProperty.all(
        //         Colors.transparent), // Make the button transparent
        //     textStyle: MaterialStateProperty.all(
        //         const TextStyle(color: tBlue)), // Set text color to tBlue
        //   ),
        //   child: const Text("Set"),
        // ),
      ],
    );
  }
}
