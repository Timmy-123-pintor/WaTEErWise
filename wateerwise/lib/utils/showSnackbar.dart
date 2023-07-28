import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext? context, String text) {
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  } else {
    if (kDebugMode) {
      print('Cannot show snackbar because context is null: $text');
    }
  }
}
