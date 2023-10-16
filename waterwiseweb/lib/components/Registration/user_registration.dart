// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterwiseweb/components/TabBar/NavBar.dart';
import 'package:waterwiseweb/constants/cons.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceUIDController = TextEditingController();
  final List<String> deviceTypes = ['ESP32', 'ESP8266'];
  final List<String> locations = [
    'Sitio Oregano, Lawaan II',
    'Sitio Gumamela, Lawaan II',
    'Sitio Puso-an, Lawaan II',
    'Sitio Gangan, Lawaan II',
    'Sitio Luy-a, Lawaan II',
    'Sitio Lemoncito, Lawaan II',
    'Sitio Sombria, Lawaan II',
    'Sitio Manga, Lawaan II',
    'Sitio Kaimito, Lawaan II',
  ];
  String? selectedDeviceType;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _deviceNameController.dispose();
    _deviceUIDController.dispose();

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
                    height: MediaQuery.of(context).size.height / 1.5,
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
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: tGray,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Registration',
                              style: GoogleFonts.quicksand(
                                textStyle: waterStyle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Flexible(
                                child: _buildTextField(
                                  controller: _firstNameController,
                                  hint: 'First Name',
                                  icon: Icons.person,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: _buildTextField(
                                  controller: _lastNameController,
                                  hint: 'Last Name',
                                  icon: Icons.person,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            hint: 'Select Barangay',
                            items: locations,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDeviceType = value;
                              });
                            },
                            value: selectedDeviceType,
                            icon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Enter your email',
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Enter your password',
                            icon: Icons.lock,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _deviceNameController,
                            hint: 'Enter Device Name',
                            icon: Icons.device_unknown,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _deviceUIDController,
                            hint: 'Enter Device UID',
                            icon: Icons.qr_code,
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            hint: 'Select Device Type',
                            items: deviceTypes,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDeviceType = value;
                              });
                            },
                            value: selectedDeviceType,
                            icon: Icons.device_hub,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildButton(
                                text: 'Cancel',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Tabbar(),
                                    ),
                                  );
                                },
                                color: tBlue,
                              ),
                              _buildRegisterButton(context),
                            ],
                          ),
                        ],
                      ),
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

// Utility function to build text fields.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
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
        controller: controller,
        style: const TextStyle(color: tBlack),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: tBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(
            top: 25.0,
            left: 20.0,
            bottom: 25.0,
          ),
          hintStyle: const TextStyle(
            color: tGray,
            height: 1,
          ),
        ),
      ),
    );
  }

// Utility function to build dropdowns.
  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value,
    required IconData icon,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  hint,
                  style: const TextStyle(color: tGray),
                  overflow: TextOverflow.ellipsis,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(color: tBlack),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Utility function to build buttons.
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        side: BorderSide(color: color, width: 2),
        minimumSize: const Size(100, 50),
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text),
    );
  }

// Register button along with its functionality.
  Widget _buildRegisterButton(BuildContext context) {
    return Builder(
      builder: (BuildContext newContext) => ElevatedButton(
        onPressed: () async {
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();
          final firstName = _firstNameController.text.trim();
          final lastName = _lastNameController.text.trim();
          final deviceName = _deviceNameController.text.trim();
          final deviceUID = _deviceUIDController.text.trim();
          final deviceType = selectedDeviceType;

          try {
            var response = await http.post(
              Uri.parse('http://localhost:3000/user/register'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'firstName': firstName,
                'lastName': lastName,
                'email': email,
                'password': password,
                'device': {
                  'name': deviceName,
                  'uid': deviceUID,
                  'type': deviceType,
                }
              }),
            );

            if (response.statusCode == 201) {
              ScaffoldMessenger.of(newContext).showSnackBar(
                const SnackBar(
                  content: Text('Registration successful!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              var responseJson = jsonDecode(response.body);
              String errorMessage = responseJson['message'];
              ScaffoldMessenger.of(newContext).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(newContext).showSnackBar(
              const SnackBar(
                content: Text('Network error. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
            if (kDebugMode) {
              print('Network error: $e');
            }
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: tBlue,
          minimumSize: const Size(50, 50),
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Register'),
      ),
    );
  }
}
