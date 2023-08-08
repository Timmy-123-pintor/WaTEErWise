// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wateerwise/models/user_model.dart';
import 'package:wateerwise/services/firebase_auth_methods.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late Future<List<UserModel>> _futureUsers;
  final FirebaseAuthMethods _authMethods =
      FirebaseAuthMethods(FirebaseAuth.instance);

  @override
  void initState() {
    super.initState();
    _futureUsers = _authMethods.fetchAllUsers();
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Full Name: ${user.fullName}'),
              Text('Email: ${user.email}'),
              Text('Role: ${user.role.capitalize()}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserModel> nonAdminUsers = snapshot.data!
                .where((user) => user.role.toLowerCase() != 'admin')
                .toList();
            return ListView.builder(
              itemCount: nonAdminUsers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Show user details dialog when tapped
                    _showUserDetails(nonAdminUsers[index]);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(nonAdminUsers[index].fullName),
                      subtitle: Text(
                        'Role: ${nonAdminUsers[index].role.capitalize()},\nEmail: ${nonAdminUsers[index].email}',
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
