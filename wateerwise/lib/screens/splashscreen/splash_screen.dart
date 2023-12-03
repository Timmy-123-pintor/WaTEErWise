import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wateerwise/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(context);
  }

  _navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDEF4FF),
      body: Center(
        child: Image.asset('assets/images/waterwise_logo.png'),
      ),
    );
  }
}
