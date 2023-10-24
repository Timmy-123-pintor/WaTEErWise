import 'package:flutter/material.dart';
import 'package:waterwiseweb/models/user_model.dart';

class UserDashboardScreen extends StatefulWidget {
  final List<UserModel> users; // Update the type to UserModel
  final int initialIndex;

  UserDashboardScreen({required this.users, this.initialIndex = 0, Key? key})
      : super(key: key);

  @override
  _UserDashboardScreen createState() => _UserDashboardScreen();
}

class _UserDashboardScreen extends State<UserDashboardScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser =
        widget.users[_currentIndex]; // Update the type to UserModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _currentIndex > 0
                ? () {
                    setState(() {
                      _currentIndex--;
                    });
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _currentIndex < widget.users.length - 1
                ? () {
                    setState(() {
                      _currentIndex++;
                    });
                  }
                : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Name: ${currentUser.fullName}'), // Using the fullName getter from UserModel
            const SizedBox(height: 10),
            // WaterConsumption(),
            // const SizedBox(height: 10),
            // CurrentBill(),
            // const SizedBox(height: 10),
            // PrevConsumption(),
          ],
        ),
      ),
    );
  }
}
