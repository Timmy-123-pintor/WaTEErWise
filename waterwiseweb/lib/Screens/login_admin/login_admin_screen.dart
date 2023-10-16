// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterwiseweb/Screens/services/firebase_auth_methods.dart';
import 'package:waterwiseweb/components/TabBar/NavBar.dart';
import 'package:waterwiseweb/constants/cons.dart';

class EmailPasswordLogin extends StatefulWidget {
  static const routeName = '/EmailPasswordLoginWM';

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

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Please input something!');
      return;
    }

    try {
      await context.read<FirebaseAuthMethods>().loginWithEmail(
            email: email,
            password: password,
            context: context,
          );

      await _saveRememberedCredentials();

      _showSnackBar(context, 'Login Successfully!');
      Navigator.pushNamedAndRemoveUntil(
          context, Tabbar.routeName, (route) => false);
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      _showSnackBar(context, 'Wrong email or password. Try again.');
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
      body: Stack(children: [
        // Positioned(
        //   top: 80,
        //   child: _buildTop(),
        // ),
        Positioned(
          child: Center(
            child: _buildBottom(),
          ),
        ),
      ]),
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
  //             color: tBlue,
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
      width: 400,
      height: 400,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        color: tWhite,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
        child: Column(
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
            style: const TextStyle(color: tBlack),
            decoration: const InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email, color: tBlue),
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
            style: const TextStyle(color: tBlack),
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock, color: tBlue),
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                splashRadius: 20.0,
                highlightColor: Colors.transparent,
                icon: _obscureText
                    ? const Icon(Icons.visibility_off, color: tBlue)
                    : const Icon(Icons.visibility, color: tBlue),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.only(top: 25.0, left: 50.0, bottom: 25.0),
              // contentPadding: const EdgeInsets.all(0),
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
    ));
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
        Row(
          children: [
            Theme(
              data: ThemeData(
                unselectedWidgetColor:
                    tBlue, // This sets the border color for the unchecked state
              ),
              child: Checkbox(
                value: _rememberPassword,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberPassword = value!;
                  });
                },
                activeColor: tWhite, // Color of the checkbox when it's checked
                checkColor: tWhite, // Color of the check icon
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return tBlue; // Background color of the checkbox when it's checked
                  }
                  return tWhite; // Background color of the checkbox when it's unchecked
                }),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                      color:
                          tBlue), // This sets the border color for the checked state
                ),
              ),
            ),
            const Text(
              'Remember Password',
              style: TextStyle(
                  color: tBlack, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        TextButton(
          onPressed: () =>
              Provider.of<FirebaseAuthMethods>(context, listen: false)
                  .resetPassword(emailController.text, context),
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
                color: tBlack, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return InkWell(
      onTap: () {
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
        loginUser();
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          color: tBlue,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
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
