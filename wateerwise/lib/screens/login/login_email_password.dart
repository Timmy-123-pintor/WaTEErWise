// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Added this import for MethodChannel
import 'package:provider/provider.dart';
import 'package:wateerwise/constant.dart';
import 'package:wateerwise/main.dart';
import 'package:wateerwise/services/firebase_auth_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EmailPasswordLogin extends StatefulWidget {
  static const routeName = '/EmailPasswordLogin';

  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  late Color myColor;
  late Size mediaSize;
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
      if (kDebugMode) {
        print("Error loading remembered credentials: $error");
      }
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

  Future<String> getServerUrl() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      bool isEmulator = false;
      try {
        isEmulator = await const MethodChannel('flutter/emulator')
            .invokeMethod('isEmulator');
      } catch (_) {}
      return isEmulator ? 'http://10.0.2.2:3000' : 'http://192.168.158.85:3000';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // Handle iOS simulator and real device
      return 'http://localhost:3000'; // for simulator
      // return 'http://192.168.254.111:3000';
    } else {
      // Default for other platforms
      return 'http://localhost:3000';
    }
  }

  Future<void> _loginUser(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final localContext = context;

    String serverUrl = await getServerUrl();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(localContext, 'Please input something!');
      return;
    }

    try {
      if (kDebugMode) {
        print('Sending HTTP request for login');
      }
      var response = await http.post(
        Uri.parse('$serverUrl/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      if (kDebugMode) {
        print('HTTP request complete. Response: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        String customToken = jsonDecode(response.body)['token'];
        await FirebaseAuth.instance.signInWithCustomToken(customToken);
        _showSnackBar(localContext, 'Login successful!');
      } else {
        var responseJson = jsonDecode(response.body);
        String errorMessage = responseJson['message'] ?? 'Login failed.';
        _showSnackBar(localContext, errorMessage);
        return;
      }

      await _saveRememberedCredentials();

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const AuthWrapper()));
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
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/waterwise_background.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          // Positioned(
          //   top: 80,
          //   child: _buildTop(),
          // ),
          Positioned(
            bottom: 0,
            child: _buildBottom(),
          ),
        ]),
      ),
    );
  }

  // Widget _buildTop() {
  //   return SizedBox(
  //     width: mediaSize.width,
  //     child: const Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         //waterwise+ logo

  //         Text(
  //           "WATERWISE+",
  //           style: TextStyle(
  //             color: Colors.blue,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 40,
  //             letterSpacing: 2,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome",
          style: TextStyle(
              color: tBlue, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        _buildGreyText("Please login with your information"),
        const SizedBox(height: 20),
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: tWhite,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 7,
              ),
            ],
          ),
          child: TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(top: 25.0, left: 50.0, bottom: 25.0),
              hintStyle: TextStyle(
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: tWhite,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 7,
              ),
            ],
          ),
          child: TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                splashRadius: 20.0,
                highlightColor: Colors.transparent,
                icon: _obscureText
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.only(top: 25.0, left: 50.0, bottom: 25.0),
              hintStyle: const TextStyle(
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: tBlack),
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              Checkbox(
                value: _rememberPassword,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberPassword = value!;
                  });
                },
              ),
              const Expanded(
                child: Text(
                  'Remember Password',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: () =>
                Provider.of<FirebaseAuthMethods>(context, listen: false)
                    .resetPassword(emailController.text, context),
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: tBlue, fontSize: 11.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return InkWell(
      onTap: () {
        _loginUser(context);
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
      },
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: tBlue,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Text(
          "Login",
          style: TextStyle(
            color: tWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
