// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../constant.dart';

class ProfilePick extends StatefulWidget {
  const ProfilePick({Key? key}) : super(key: key);

  @override
  _ProfilePickState createState() => _ProfilePickState();
}

class _ProfilePickState extends State<ProfilePick> {
  File? _selectedImage;
  String userName = '';
  bool isLoading = false;
  String userId = '';
  String? fileName;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        setState(() {
          userName = user.displayName ?? '';
          userId = user.uid;
        });

        // Fetch the profile image URL from Firestore
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            fileName = doc['profile_picture'];
          });
        }
      } else {
        if (kDebugMode) {
          print('User is currently signed out!');
        }
      }
    });
  }

  Future<void> _pickImage() async {
    File? selectedImage;

    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        selectedImage = File(result.files.single.path!);
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        selectedImage = File(xFile.path);
      }
    }

    if (selectedImage != null) {
      setState(() {
        _selectedImage = selectedImage;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _uploadImageToFirebase(selectedImage);
      } else {
        print('User is not authenticated');
      }
    }
  }

  Future<void> getDownloadURL() async {
    final ref = FirebaseStorage.instance.ref('profile_images');
    String url = await ref.getDownloadURL();
    print(url);
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String fileName = basename(imageFile.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('profile_images/${user.uid}/$fileName');

      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        var downloadURL = await ref.getDownloadURL();
        print("Image uploaded successfully: $downloadURL");

        // Update the user's profile picture in Firebase Authentication
        await user.updateProfile(photoURL: downloadURL);

        // Update the user's profile picture in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'profile_picture': downloadURL,
        });

        // Update _selectedImage to display the new image
        setState(() {
          _selectedImage = imageFile;
        });
      });
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      : (fileName != null
                          ? DecorationImage(
                              image: NetworkImage(fileName!),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage('images/waterwise.png'),
                              fit: BoxFit.cover,
                            )),
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
