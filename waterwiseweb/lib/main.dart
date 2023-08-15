import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:waterwiseweb/Screens/login_admin/login_admin_screen.dart';
import 'package:waterwiseweb/Screens/services/firebase_auth_methods.dart';
import 'package:waterwiseweb/components/TabBar/NavBar.dart';
import 'package:waterwiseweb/constants/cons.dart';
import 'package:waterwiseweb/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyAppHome(),
        routes: {
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          Tabbar.routeName: (context) => const Tabbar(),
        },
      ),
    );
  }
}

class MyAppHome extends StatelessWidget {
  const MyAppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final double appBarHeight = 70 / devicePixelRatio;
    final firebaseUser = context.watch<User?>();

    return Scaffold(
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
      body: firebaseUser != null ? const Tabbar() : const EmailPasswordLogin(),
    );
  }
}
