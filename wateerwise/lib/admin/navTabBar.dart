// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_this, file_names, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wateerwise/admin/bill.dart';
import 'package:wateerwise/admin/devicesMob.dart';
import 'package:wateerwise/admin/userAdd.dart';
import 'package:wateerwise/screens/mainpage.dart';

import '../constant.dart';

class Tabbar extends StatefulWidget {
  static const routeName = '/Tabbar';
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedTab = 0;
  bool extended = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logout() async {
    await _auth.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/EmailPasswordLogin', (route) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: _selectedTab,
              onTap: (index) {
                if (index == 4) {
                  logout();
                } else {
                  setState(() {
                    this._selectedTab = index;
                  });
                }
              },
              selectedItemColor: tBlue,
              unselectedItemColor: tBlack,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: "Users",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: "Bill",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2),
                  label: "Devices",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_add),
                  label: "Add user",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout),
                  label: "Logout",
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    extended = !extended;
                  });
                },
                child: NavigationRail(
                  onDestinationSelected: (int index) {
                    if (index == 4) {
                      logout();
                    } else {
                      setState(() {
                        _selectedTab = index;
                      });
                    }
                  },
                  extended: extended,
                  selectedIndex: _selectedTab,
                  selectedIconTheme: IconThemeData(
                    color: tBlue,
                  ),
                  selectedLabelTextStyle: TextStyle(
                    color: tBlue,
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_filled),
                      label: Text("Users"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.map),
                      label: Text("Bill"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_2),
                      label: Text("Devices"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_add),
                      label: Text("Add User"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.logout),
                      label: Text("Logout"),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                renderView(
                  0,
                  const MainPage(),
                ),
                renderView(
                  1,
                  Bill(),
                ),
                renderView(
                  2,
                  const DevicesMob(),
                ),
                renderView(
                  3,
                  const AddUser(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderView(int tabIndex, Widget view) {
    return IgnorePointer(
      ignoring: _selectedTab != tabIndex,
      child: Opacity(
        opacity: _selectedTab == tabIndex ? 1 : 0,
        child: view,
      ),
    );
  }
}
