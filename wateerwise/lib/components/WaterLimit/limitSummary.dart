// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/provider/provider.dart';

class SummaryDialog extends StatefulWidget {
  final String timeDuration;

  const SummaryDialog({
    Key? key,
    required double cubicMeter,
    required this.timeDuration,
  }) : super(key: key);

  @override
  State<SummaryDialog> createState() => _SummaryDialogState();
}

class _SummaryDialogState extends State<SummaryDialog> {
  late Timer _timer;
  int _secondsLeft = 10;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _closeDialog();
      }
    });
  }

  void _closeDialog() {
    Navigator.of(context).pop();
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 600),
      child: AlertDialog(
        title: const Text("Summary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You have set your limit to:'),
            Text(
                "Cubic meter: ${progressProvider.maxValue}\nTime Duration: ${widget.timeDuration}"),
            if (_secondsLeft > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                    'This will automatically close in $_secondsLeft seconds'),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: _closeDialog,
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }
}
