import 'package:flutter/material.dart';
import 'package:waterwiseweb/constants/cons.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: tRed,
            height: 500,
            width: double.infinity,
          )
        ],
      ),
    );
  }
}
