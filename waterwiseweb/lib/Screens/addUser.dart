import 'package:flutter/material.dart';
import 'package:waterwiseweb/components/Registration/user_registration.dart';
import 'package:waterwiseweb/constants/cons.dart';

class DialogueBox extends StatelessWidget {
  const DialogueBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: tWhite,
      body: AddUser(),
    );
  }
}
