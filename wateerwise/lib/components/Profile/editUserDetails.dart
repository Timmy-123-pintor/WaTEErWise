// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, unused_element, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/components/Profile/passwordConfirmation.dart';
import 'package:wateerwise/components/Profile/passwordReset.dart';
import 'package:wateerwise/provider/provider.dart';
import 'package:wateerwise/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class UserEditDetails extends StatefulWidget {
  const UserEditDetails({Key? key}) : super(key: key);

  @override
  State<UserEditDetails> createState() => _UserEditDetailsState();
}

class _UserEditDetailsState extends State<UserEditDetails> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isEditMode = false;

  Future<bool> _openPasswordConfirmation(BuildContext context) async {
    final isPasswordConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return PasswordConfirmation();
      },
    );
    return isPasswordConfirmed ?? false;
  }

  @override
  void initState() {
    super.initState();
    final phoneNumberProvider =
        Provider.of<PhoneNumberProvider>(context, listen: false);
    phoneNumberProvider.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumberProvider =
        Provider.of<PhoneNumberProvider>(context, listen: false);
    String userEmail = '';

    void fetchUserEmail() async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          setState(() {
            userEmail = user.email ?? '';
          });
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error fetching user email: $error');
        }
      }
    }

    fetchUserEmail();

    void _unfocusTextField() {
      FocusScope.of(context).unfocus();
    }

    Future<void> toggleEditMode() async {
      if (isEditMode) {
        setState(() {
          isEditMode = false;
        });
      } else {
        final isPasswordConfirmed = await _openPasswordConfirmation(context);
        if (isPasswordConfirmed) {
          setState(() {
            isEditMode = !isEditMode;
          });
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        _unfocusTextField();
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: GoogleFonts.quicksand(
              textStyle: appBar,
            ),
          ),
          backgroundColor: tBlue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _unfocusTextField();
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: tBlue,
                  ),
                  shape: BoxShape.circle,
                  color: tGray,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Melvin P. Forbis",
                style: GoogleFonts.quicksand(
                  textStyle: name,
                ),
              ),
            ),
            Center(
              child: Text(
                "Account No. 202300010",
                style: GoogleFonts.quicksand(
                  textStyle: accId,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the Row horizontally
                    children: [
                      Icon(
                        Icons.edit,
                        color: tBlue,
                        size: 20,
                      ),
                      isEditMode
                          ? TextButton(
                              onPressed: () {
                                toggleEditMode();
                              },
                              child: const Text(
                                "Done",
                                style: TextStyle(color: tBlue),
                              ),
                            )
                          : TextButton(
                              onPressed: toggleEditMode,
                              child: const Text(
                                'Edit',
                                style: TextStyle(color: tBlue),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Email
            Padding(
              padding: const EdgeInsets.all(20), // Adjust the padding as needed
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Vertically align to the center
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10), // Adjust the padding as needed
                        child: Image.asset(
                          'assets/images/mailb.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      Text(
                        userEmail,
                        style: GoogleFonts.quicksand(
                          textStyle: name,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/images/contact.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: isEditMode
                              ? phoneNumberController
                              : TextEditingController(
                                  text: phoneNumberProvider.phoneNumber),
                          decoration: const InputDecoration(
                            hintText: "Enter phone number",
                          ),
                          enabled: isEditMode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                        ),
                      ),
                      if (isEditMode)
                        TextButton(
                          onPressed: () {
                            phoneNumberProvider.phoneNumber =
                                phoneNumberController.text;
                            _unfocusTextField();
                          },
                          child: const Text(
                            "Set",
                            style: TextStyle(
                              color: tBlue,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Change Password
                  isEditMode
                      ? InkWell(
                          child: GestureDetector(
                            onTap: () {
                              if (isEditMode) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const PasswordReset();
                                    });
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset(
                                    'assets/images/settings.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                Text(
                                  "Change Password",
                                  style: GoogleFonts.quicksand(
                                    textStyle: name,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                'assets/images/settings.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            Text('Change Password',
                                style: GoogleFonts.quicksand(
                                  textStyle: textGray15,
                                )),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
