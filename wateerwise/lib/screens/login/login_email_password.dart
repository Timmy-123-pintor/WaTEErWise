// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/admin/navTabBar.dart';
import 'package:wateerwise/components/UpperNavBar/upNavBar.dart';
import 'package:wateerwise/services/firebase_auth_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailPasswordLogin extends StatefulWidget {
  static const routeName = '/EmailPasswordLogin';

  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _obscureText = true;
  bool _rememberPassword = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _loadRememberedCredentials();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberedCredentials() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        emailController.text = prefs.getString('saved_email') ?? '';
        passwordController.text = prefs.getString('saved_password') ?? '';
        _rememberPassword = prefs.getBool('saved_remember_password') ?? false;
      });
    } catch (error) {
      print("Error loading remembered credentials: $error");
    }
  }

  Future<void> _saveRememberedCredentials() async {
    if (_rememberPassword) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_email', emailController.text.trim());
        await prefs.setString('saved_password', passwordController.text.trim());
        await prefs.setBool('saved_remember_password', _rememberPassword);
      } catch (error) {
        if (kDebugMode) {
          print("Error saving remembered credentials: $error");
        }
      }
    }
  }

  Future<void> _loginUser(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final localContext = context;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(localContext, 'Please input something!');
      return;
    }

    try {
      UserCredential userCredential =
          await Provider.of<FirebaseAuthMethods>(localContext, listen: false)
              .loginWithEmail(
        email: email,
        password: password,
        context: localContext,
      );

      if (userCredential.user?.uid == null) {
        if (kDebugMode) {
          print('Failed to get user UID');
        }
        return;
      }

      String? role =
          await Provider.of<FirebaseAuthMethods>(localContext, listen: false)
              .getUserRole(userCredential.user!.uid);

      if (kDebugMode) {
        print('Fetched user role: $role');
      }

      await _saveRememberedCredentials();

      if (mounted) {
        // Check if the widget is still in the tree
        if (role == 'admin') {
          Navigator.pushNamedAndRemoveUntil(
              localContext, Tabbar.routeName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              localContext, UpTabBar.routeName, (route) => false);
        }

        _showSnackBar(localContext, 'Login successful!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      _showSnackBar(localContext, 'Wrong email or password. Try again.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: _obscureText
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberPassword,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberPassword = value!;
                          });
                        },
                      ),
                      const Text('Remember Password'),
                    ],
                  ),
                  TextButton(
                    onPressed: () =>
                        Provider.of<FirebaseAuthMethods>(context, listen: false)
                            .resetPassword(emailController.text, context),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _loginUser(context),
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
      ),
    );
  }
}
