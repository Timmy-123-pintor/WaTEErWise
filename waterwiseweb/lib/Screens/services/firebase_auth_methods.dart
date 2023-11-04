// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waterwiseweb/Screens/utils/showSnackbar.dart';
import 'package:waterwiseweb/models/user_model.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String location,
    required String deviceName,
    required String deviceUID,
    required String deviceType,
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
            'location': location,
            'deviceName': deviceName,
            'deviceUID': deviceUID,
            'deviceType': deviceType,
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

// EMAIL LOGIN
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Attempt to sign in without changing the auth state yet
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user is an admin before finalizing login
      String? role = await getUserRole(userCredential.user!.uid);
      if (role != 'admin') {
        // Sign out the user immediately if not an admin
        await _auth.signOut();
        throw FirebaseAuthException(
            code: 'not-admin', message: 'Only admin accounts can log in here.');
      }

      // If the user is an admin, return the UserCredential
      return userCredential;
    } on FirebaseAuthException {
      rethrow; // Re-throw the exception to be caught by the calling method
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // RESET PASSWORD
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
          location: data['location'] as String? ?? '',
          deviceType: data['deviceType'] as String? ?? '',
          deviceName: data['deviceName'] as String? ?? '',
          deviceUID: data['deviceUID'] as String? ?? '',
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
  Future<void> deleteUser(String uid, BuildContext context) async {
    try {
      // Delete the user document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      // Optionally, delete the user from Firebase Auth as well
      // Note: This requires the user to be signed in and have the appropriate permissions
      // await FirebaseAuth.instance.currentUser!.delete();

      showSnackBar(context, 'User deleted successfully');
      // You may want to set state or refresh the user list here as well.
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
      showSnackBar(context, 'Error deleting user');
    }
  }
}
