// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:waterwiseweb/Screens/services/firebase_auth_methods.dart';
import 'package:waterwiseweb/components/TabBar/NavBar.dart';
import 'package:waterwiseweb/constants/cons.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  // Add controllers for your TextFields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 640;

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Background Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              constraints: const BoxConstraints.expand(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Row(
              children: [
                if (isDesktop(context))
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: const BoxDecoration(
                      color: tBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'WaterWise+',
                          style: GoogleFonts.quicksand(
                            textStyle: waterWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: tWhite,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            color: tBlack,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Tabbar(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Center(
                          child: Text(
                            'Registration',
                            style: GoogleFonts.quicksand(
                              textStyle: waterStyle,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                  prefixIcon: Icon(Icons.person),
                                  prefixIconColor: tBlack,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                  prefixIcon: Icon(Icons.person),
                                  prefixIconColor: tBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            prefixIconColor: tBlack,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            prefixIconColor: tBlack,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final firstName = _firstNameController.text.trim();
                            final lastName = _lastNameController.text.trim();

                            try {
                              var response = await http.post(
                                Uri.parse(
                                    'http://localhost:3000/user/register'),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                                body: jsonEncode(<String, String>{
                                  'firstName': firstName,
                                  'lastName': lastName,
                                  'email': email,
                                  'password': password,
                                  'isAdmin':
                                      'false', // set 'isAdmin' directly as 'false'
                                }),
                              );

                              if (response.statusCode == 200) {
                                try {
                                  await context
                                      .read<FirebaseAuthMethods>()
                                      .signUpWithEmail(
                                        email: email,
                                        password: password,
                                        firstName: firstName,
                                        lastName: lastName,
                                        context: context,
                                      );
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  // Handle signup error
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                }
                              } else {
                                // Handle backend server error
                                if (kDebugMode) {
                                  print('Server error: ${response.statusCode}');
                                }
                              }
                            } catch (e) {
                              // Handle network error
                              if (kDebugMode) {
                                print('Network error: $e');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue, // Set the text color
                            minimumSize:
                                const Size(50, 50), // Set the button size
                            padding:
                                const EdgeInsets.all(10), // Set the padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Set the border radius
                            ),
                          ),
                          child: const Text('Register'), // Button text
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
