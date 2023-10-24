// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant.dart';

class ProfilePick extends StatefulWidget {
  const ProfilePick({super.key});

  @override
  _ProfilePickState createState() => _ProfilePickState();
}

class _ProfilePickState extends State<ProfilePick> {
  File? _selectedImage;
  String userName = '';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void fetchUser() async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          setState(() {
            userName = user.displayName ?? '';
          });
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error fetching user email: $error');
        }
      }
    }

    fetchUser();

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: tBlue,
                  ),
                  shape: BoxShape.circle,
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: tBlack,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3,
                        color: tWhite,
                      ),
                      color: tGray,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: tWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            userName,
            style: GoogleFonts.quicksand(
              textStyle: name,
            ),
          ),
          Text(
            "Account No. 202300010",
            style: GoogleFonts.quicksand(
              textStyle: accId,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 130,
            height: 30,
            decoration: const BoxDecoration(
              color: tOrangeO,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                " • Restricted",
                style: GoogleFonts.inter(
                  textStyle: status,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "Peak Water Consumption and Billing",
                style: GoogleFonts.quicksand(
                  textStyle: profileText,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 100,
                height: 30,
                decoration: const BoxDecoration(
                  color: tBlueO,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    "January 2023",
                    style: GoogleFonts.inter(
                      textStyle: profileRow,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: 100,
                height: 30,
                decoration: const BoxDecoration(
                  color: tBlueO,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    "62 m3",
                    style: GoogleFonts.inter(
                      textStyle: profileRow,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: 100,
                height: 30,
                decoration: const BoxDecoration(
                  color: tBlueO,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    "P 1860",
                    style: GoogleFonts.inter(
                      textStyle: profileRow,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 29),
            child: Row(
              children: [
                Text(
                  "Month",
                  style: GoogleFonts.quicksand(
                    textStyle: profileText,
                  ),
                ),
                const SizedBox(
                  width: 35,
                ),
                Text(
                  "Water Consumption",
                  style: GoogleFonts.quicksand(
                    textStyle: profileText,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  "Bill Amount",
                  style: GoogleFonts.quicksand(
                    textStyle: profileText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
