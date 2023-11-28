// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterwiseweb/Screens/bill.dart';
import 'package:waterwiseweb/components/Dashboard/all_users_screen.dart';
import 'package:waterwiseweb/components/Devices/user_devices.dart';
import 'package:waterwiseweb/constants/cons.dart';

class Tabbar extends StatefulWidget {
  static const routeName = '/Tabbar';
  const Tabbar({Key? key}) : super(key: key);

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
        .pushNamedAndRemoveUntil('/EmailPasswordLoginWM', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: _selectedTab,
              onTap: (index) {
                if (index == 3) {
                  logout();
                } else {
                  setState(() {
                    _selectedTab = index;
                  });
                }
              },
              selectedItemColor: tBlue,
              unselectedIconTheme: const IconThemeData(color: tBlack),
              unselectedItemColor: tBlack,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled), label: "Users"),
                BottomNavigationBarItem(icon: Icon(Icons.map), label: "Bill"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2), label: "Devices"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.logout), label: "Logout"),
              ],
            )
          : null,
      body: Container(
        color: tNavBar,
        child: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 640)
              GestureDetector(
                onTap: () {
                  setState(() {
                    extended = !extended;
                  });
                },
                child: NavigationRail(
                  backgroundColor: tBlue,
                  extended: extended,
                  selectedIndex: _selectedTab,
                  onDestinationSelected: (index) {
                    if (index == 3) {
                      logout();
                    } else {
                      setState(() {
                        _selectedTab = index;
                      });
                    }
                  },
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.water_drop_outlined,
                          color: tWhite,
                          size: 35.0,
                        ),
                        if (extended) // Only show the text if the rail is extended
                          Text(
                            'WaterWise+',
                            style: GoogleFonts.quicksand(
                              textStyle: waterStyleW,
                            ),
                          ),
                      ],
                    ),
                  ),
                  selectedIconTheme: const IconThemeData(color: tBlue),
                  selectedLabelTextStyle: const TextStyle(color: tWhite),
                  unselectedLabelTextStyle: const TextStyle(color: tWhite),
                  unselectedIconTheme: const IconThemeData(color: tWhite),
                  useIndicator: true,
                  indicatorColor: tWhite,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.groups,
                      ),
                      label: Text("Users"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.payment),
                      label: Text("Bill"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.perm_device_info,
                      ),
                      label: Text("Devices"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.logout),
                      label: Text("Logout"),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  renderView(0, const Table02UserListWidget()),
                  renderView(1, const Bill()),
                  renderView(2, DeviceScreen()),
                ],
              ),
            ),
          ],
        ),
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
