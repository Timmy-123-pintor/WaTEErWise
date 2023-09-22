// ignore_for_file: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateerwise/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEditDetails extends StatefulWidget {
  const UserEditDetails({super.key});

  @override
  State<UserEditDetails> createState() => _UserEditDetailsState();
}

class _UserEditDetailsState extends State<UserEditDetails> {
  String userEmail = "";

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  Future<void> fetchUserEmail() async {
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

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            //Edit Profile field :)
          ),
          const SizedBox(height: 10),

          // Email
          ListTile(
            title: const Text("Email"),
            subtitle: Text(userEmail),
          ),

          // Contact Number
          ListTile(
            title: const Text("Contact Number"),
            subtitle: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: "Enter phone number",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Change Password
          ListTile(
            title: const Text("Change Password?"),
            subtitle: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: "Enter new password",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle change password action
                    // You can implement this logic to update the password
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
