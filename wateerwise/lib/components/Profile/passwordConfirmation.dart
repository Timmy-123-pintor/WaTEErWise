// ignore_for_file: use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/constant.dart';

class PasswordConfirmation extends StatefulWidget {
  const PasswordConfirmation({super.key});

  @override
  State<PasswordConfirmation> createState() => _PasswordConfirmationState();
}

class _PasswordConfirmationState extends State<PasswordConfirmation> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordCorrect = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Password Confirmation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Warning',
            style: GoogleFonts.quicksand(
              textStyle: text20Red,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Please input your password before continuing. Just to make sure if it is you',
            style: GoogleFonts.quicksand(
              textStyle: text15Blue,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Enter your password',
              floatingLabelStyle: GoogleFonts.quicksand(
                textStyle: text15Blue,
              ),
              errorText: _isPasswordCorrect ? null : 'Incorrect Password',
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: tBlue),
              ),
            ),
            style: TextStyle(
              color: _isPasswordCorrect ? tBlack : tRed,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  // Implement your "Forgot Password" logic here.
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: user.email!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset email sent.'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: Unable to send reset email.'),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.quicksand(
                    textStyle: text12Blue,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            'Cancel',
            style: GoogleFonts.quicksand(
              textStyle: text15Blue,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false); // Return false if canceled.
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(tBlue),
          ),
          child: Text(
            'Confirm',
            style: GoogleFonts.quicksand(
              textStyle: text12White,
            ),
          ),
          onPressed: () async {
            // Verify the password with Firebase.
            _isPasswordCorrect =
                await _verifyPassword(_passwordController.text);
            if (_isPasswordCorrect) {
              Navigator.of(context).pop(true);
            } else {
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Future<bool> _verifyPassword(String? enteredPassword) async {
    if (enteredPassword == null) {
      // Handle the case where enteredPassword is null.
      return false; // Password is incorrect.
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: enteredPassword);
        await user.reauthenticateWithCredential(credential);
        return true; // Password is correct.
      }
    } catch (e) {
      if (kDebugMode) {
        print('Password verification error: $e');
      }
    }
    return false; // Password is incorrect.
  }
}
