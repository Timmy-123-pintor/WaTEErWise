// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waterwiseweb/Screens/services/firebase_auth_methods.dart';
import 'package:waterwiseweb/components/Dashboard/userDashboardScreen.dart';
import 'package:waterwiseweb/models/user_model.dart';

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
                    if (kDebugMode) {
                      print('User pressed: ${nonAdminUsers[index].fullName}');
                    }

                    // Navigate to UserDashboardScreen when a user is tapped
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserDashboardScreen(
                        users: nonAdminUsers,
                        initialIndex: index,
                      ),
                    ));
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(nonAdminUsers[index]
                          .fullName), // Using the fullName getter from UserModel
                      subtitle: Text(
                        'Role: ${nonAdminUsers[index].role.capitalize()}\nEmail: ${nonAdminUsers[index].email}',
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
