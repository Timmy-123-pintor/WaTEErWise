// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/admin/navTabBar.dart';
import 'package:wateerwise/components/UpperNavBar/upNavBar.dart';
import 'package:wateerwise/services/firebase_auth_methods.dart';
import 'package:wateerwise/widgets/custom_textfiled.dart';

class EmailPasswordLogin extends StatefulWidget {
  static const routeName = '/EmailPasswordLogin';
  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      String? role = await context.read<FirebaseAuthMethods>().loginWithEmail(
            email: email,
            password: password,
            context: context,
          );
      if (role != null) {
        if (role == 'admin') {
          Navigator.pushNamedAndRemoveUntil(
              context, Tabbar.routeName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, UpTabBar.routeName, (route) => false);
        }
      } else {
        // Handle error here
      }
    } catch (e) {
      // Handle login error here
      if (kDebugMode) {
        print('Login error: $e');
      }
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Login",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: loginUser,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
