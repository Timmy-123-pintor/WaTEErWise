// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/constant.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  int _timerCountdown = 60;
  bool _isVisible = true;
  late Timer _countdownTimer;
  Color _buttonColor = tBlue;

  @override
  void initState() {
    super.initState();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCountdown > 0) {
        setState(() {
          _timerCountdown--;
          if (_timerCountdown <= 30) {
            _buttonColor = tOrange;
          }
          if (_timerCountdown <= 15) {
            _buttonColor = tRed;
          }
        });
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: AlertDialog(
        title: Text(
          'Reset Password',
          style: GoogleFonts.quicksand(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send password reset request to email',
              style: GoogleFonts.quicksand(
                textStyle: text15Blue,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Auto-dismiss in $_timerCountdown seconds',
              style: GoogleFonts.quicksand(
                textStyle: information,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        actions: [
          Center(
              child: GestureDetector(
            onTap: () {
              // Add your logic here
            },
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: _buttonColor, // Background color
                borderRadius:
                    BorderRadius.circular(10), // Add rounded corners if desired
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width *
                    0.04, // Adjust the padding as needed
                vertical: MediaQuery.of(context).size.height *
                    0.015, // Adjust the padding as needed
              ),
              child: Text(
                'Send',
                style: GoogleFonts.quicksand(
                  textStyle: text15White, // Use your defined tWhite style
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
