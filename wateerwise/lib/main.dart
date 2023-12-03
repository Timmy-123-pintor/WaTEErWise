// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/admin/navTabBar.dart';
import 'package:wateerwise/components/UpperNavBar/upNavBar.dart';
import 'package:wateerwise/firebase_options.dart';
import 'package:wateerwise/provider/provider.dart';
import 'package:wateerwise/screens/login/login_email_password.dart';
import 'package:wateerwise/screens/splashscreen/splash_screen.dart';
import 'package:wateerwise/services/firebase_auth_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    await FirebaseAppCheck.instance.activate();
  }
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
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        ChangeNotifierProvider<PhoneNumberProvider>(
          create: (_) => PhoneNumberProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgressProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TimerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ButtonStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SummaryDialogProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WaterConsumptionProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WaterWise+',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          Tabbar.routeName: (context) => const Tabbar(),
          UpTabBar.routeName: (context) => const UpTabBar(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user != null) {
            return FutureBuilder<String>(
              future: getUserRole(user),
              builder:
                  (BuildContext context, AsyncSnapshot<String> roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.done) {
                  return AuthWrapper(role: roleSnapshot.data!);
                } else {
                  return const Center(child: SplashScreen());
                }
              },
            );
          } else {
            return const EmailPasswordLogin();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<String> getUserRole(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()?['role'] ?? 'user';
  }
}

class AuthWrapper extends StatefulWidget {
  final String role;

  const AuthWrapper({Key? key, required this.role}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    if (widget.role == 'admin') {
      return const Tabbar();
    } else if (widget.role == 'user') {
      return const UpTabBar();
    } else {
      return const EmailPasswordLogin();
    }
  }
}
