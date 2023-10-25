// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/constant.dart';
import 'package:wateerwise/provider/provider.dart';

class InputTextField extends StatefulWidget {
  const InputTextField({super.key});

  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasError = false;
  bool showError = false;
  String selectedValue = 'Choose';

  final List<String> items = [
    'Choose',
    '1 Week',
    '2 Weeks',
    '1 Month',
  ];

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
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    if (_controller.text.isEmpty || selectedValue == 'Choose') {
      setState(() {
        _hasError = true;
      });
    } else {
      setState(() {
        _hasError = false;
      });
      final newValue = double.tryParse(_controller.text);
      if (newValue != null) {
        progressProvider.setMaxValue(newValue);
        timerProvider.setDuration(selectedValue);
        timerProvider.startTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final buttonStateProvider = Provider.of<ButtonStateProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear,
                height: 43,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  color: tWhite,
                  border: !_hasError
                      ? null
                      : selectedValue == 'Choose'
                          ? Border.all(color: tRed, width: 2)
                          : null,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter Value here',
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
                    setState(() {
                      showError = false;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              //Drop downbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear,
                height: 45,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  color: tWhite,
                  border: !_hasError
                      ? null
                      : selectedValue == 'Choose'
                          ? Border.all(color: tRed, width: 2)
                          : null,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Duration',
                        style: GoogleFonts.quicksand(textStyle: navText),
                      ),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          GestureDetector(
            // onTap: _validateInput,
            onTap: () {
              setState(() {
                showError =
                    (_controller.text.isEmpty || selectedValue == 'Choose');
              });
              if (buttonStateProvider.isSetButton) {
                _validateInput();
                if (!showError) {
                  buttonStateProvider.setCancelButton();
                }
              } else {
                buttonStateProvider.setSetButton();
              }
            },
            child: Container(
              height: 41,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: buttonStateProvider.isSetButton
                    ? tBlue
                    : tRed, // Set the container color to tBlue
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  buttonStateProvider.isSetButton ? "Set" : "Cancel",
                  style: const TextStyle(
                      color: tWhite), // Set text color to tWhite
                ),
              ),
            ),
          ),
          if (!buttonStateProvider.isSetButton &&
              timerProvider.timerDurationInSeconds > 0)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: tWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Timer: ${timerProvider.daysLeft} days, ${timerProvider.hoursLeft} hours, and ${timerProvider.minutesLeft} minutes left',
                style: GoogleFonts.quicksand(
                  textStyle: text15Blue,
                ),
              ),
            ),
          if (showError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Error, no desired limit detected.',
                style: Constant.warning15(context),
              ),
            )
        ],
      ),
    );
  }
}
