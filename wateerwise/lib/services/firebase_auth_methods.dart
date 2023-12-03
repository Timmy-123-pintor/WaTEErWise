// ignore_for_file: use_build_context_synchronously, avoid_print
// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wateerwise/models/user_model.dart';
import 'package:wateerwise/provider/provider.dart';
import 'package:wateerwise/utils/showSnackbar.dart';
// import 'package:http/http.dart' as http;

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return;
      }

      // Add the user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'role': 'user',
            // 'contactNumber': updateUserPhoneNumber,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      User? user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        showSnackBar(context, 'Email verification sent!');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
      showSnackBar(context, e.message!);
    }
  }

// // EMAIL LOGIN
// Future<Map<String, dynamic>> loginWithEmail({
//   required String email,
//   required String password,
//   required BuildContext context,
// }) async {
//   try {
//     // Send HTTP request to server for login
//     var response = await http.post(
//       Uri.parse('http://localhost:3000/user/login'),
//       body: {'email': email, 'password': password},
//     );

//     // Parse response body
//     var responseBody = jsonDecode(response.body);

//     // Get custom token from response body
//     String customToken = responseBody['customToken'];

//     // Use custom token to sign in
//     UserCredential userCredential = await _auth.signInWithCustomToken(customToken);

//     print('UserCredential: $userCredential');

//     if (userCredential.user == null) {
//       throw FirebaseAuthException(
//           code: 'user-not-found', message: 'No user found for that email.');
//     }

//     String uid = userCredential.user!.uid;
//     DocumentSnapshot userDoc =
//         await FirebaseFirestore.instance.collection('users').doc(uid).get();

//     print('UserDoc: $userDoc');

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         print('No user is logged in');
//       } else {
//         print('User is logged in: ${user.uid}');
//       }
//     });

//     String role = 'user';
//     if (userDoc.exists) {
//       Map<String, dynamic>? userData =
//           userDoc.data() as Map<String, dynamic>?;
//       print('UserData: $userData');
//       if (userData != null) {
//         role = userData['role'] ?? 'user';
//       }
//     }

//     print('Role: $role');

//     // Return both UserCredential and role
//     return {
//       'userCredential': userCredential,
//       'role': role,
//     };
//   } on FirebaseAuthException catch (e) {
//     String errorMessage = '';
//     if (e.code == 'user-not-found') {
//       errorMessage = 'No user found for that email.';
//     } else if (e.code == 'wrong-password') {
//       errorMessage = 'Wrong password provided for that user.';
//     } else {
//       errorMessage = 'Login Failed!';
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(errorMessage)),
//     );

//     rethrow;
//   }
// }

// Future<void> loginWithCustomToken({
//   required String email,
//   required String password,
//   required BuildContext context,
// }) async {
//   try {
//     // Send HTTP request to your Node.js backend
//     final response = await http.post(
//       Uri.parse('http://localhost:3000/user/login'),
//       body: {'email': email, 'password': password},
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final customToken = data['customToken'];

//       // Sign in with the custom token
//       await _auth.signInWithCustomToken(customToken);
//     } else {
//       showSnackBar(context, 'Login failed: ${response.body}');
//     }
//   } catch (e) {
//     showSnackBar(context, 'Error: $e');
//   }
// }


  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //RESET PASSWORD
  Future<void> resetPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address!')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Password reset error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Try again.')),
      );
    }
  }

  // GET USER ROLE
  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var data = userDoc.data();
    if (data is Map<String, dynamic>) {
      return data['role'] as String? ?? 'user';
    } else {
      return 'user';
    }
  }

  // FETCH ALL USERS
  Future<List<UserModel>> fetchAllUsers() async {
    List<UserModel> users = [];
    var userDocs = await FirebaseFirestore.instance.collection('users').get();

    if (kDebugMode) {
      print('Fetched ${userDocs.docs.length} user(s)');
    }

    for (var userDoc in userDocs.docs) {
      var data = userDoc.data();
      if (kDebugMode) {
        print('Data for user ${userDoc.id}: $data');
      }
      users.add(
        UserModel(
          uid: userDoc.id,
          email: data['email'] as String? ?? '',
          role: data['role'] as String? ?? 'user',
          firstName: data['firstName'] as String? ?? '',
          lastName: data['lastName'] as String? ?? '',
        ),
      );
    }
    return users;
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
      // Do something after successful account deletion (e.g., navigate to login screen)
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }

  //added phone number data
  Future<void> updateUserPhoneNumber(
      String newPhoneNumber, PhoneNumberProvider phoneNumberProvider) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userReference =
            FirebaseFirestore.instance.collection('users').doc(userId);

        userReference.update({
          'contactNumber': newPhoneNumber,
        }).then((_) {
          print('Contact number updated successfully');
        }).catchError((error) {
          print('Error updating contact number: $error');
        });
      }
    } catch (error) {
      print('Error updating contact number: $error');
    }
  }
}
