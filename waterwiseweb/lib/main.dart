import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterwiseweb/components/TabBar/NavBar.dart';
import 'package:waterwiseweb/cons.dart';
import 'package:waterwiseweb/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final double appBarHeight = 70 / devicePixelRatio;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AppBar(
              scrolledUnderElevation: 1.0,
              title: Row(
                children: [
                  Text(
                    'WaterWise+',
                    style: GoogleFonts.quicksand(
                      textStyle: waterStyle,
                    ),
                  ),
                ],
              ),
              backgroundColor: tWhite,
              elevation: 0.0,
            ),
          ),
        ),
        body: const Tabbar(),
      ),
    );
  }
}
