import 'package:flutter/material.dart';
import '../Components/Profile/accountInfo.dart';
import '../components/Profile/profilePicker.dart';
import '../constant.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBlue,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: tWG,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    ProfilePick(),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: tBlue,
                      thickness: 1.0,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AccounntInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
