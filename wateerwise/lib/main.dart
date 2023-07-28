import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/admin/navTabBar.dart';
import 'package:wateerwise/components/UpperNavBar/upNavBar.dart';
import 'package:wateerwise/firebase_options.dart';
import 'package:wateerwise/screens/login/login_email_password.dart';
import 'package:wateerwise/services/firebase_auth_methods.dart';

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
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        routes: {
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          Tabbar.routeName: (context) => const Tabbar(),
          UpTabBar.routeName: (context) => const UpTabBar(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<String?> userRoleFuture;

  @override
  void initState() {
    super.initState();
    userRoleFuture = initUserRole();
  }

  Future<String?> initUserRole() async {
    final firebaseUser = context.read<User?>();
    if (firebaseUser != null) {
      return await context
          .read<FirebaseAuthMethods>()
          .getUserRole(firebaseUser.uid);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return FutureBuilder<String?>(
        future:
            context.read<FirebaseAuthMethods>().getUserRole(firebaseUser.uid),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 'admin') {
              return const Tabbar();
            } else {
              return const UpTabBar();
            }
          } else {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          }
        },
      );
    } else {
      return const EmailPasswordLogin();
    }
  }
}
