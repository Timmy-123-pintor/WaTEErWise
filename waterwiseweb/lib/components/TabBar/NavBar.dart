import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                if (index == 4) {
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
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            GestureDetector(
              onTap: () {
                setState(() {
                  extended = !extended;
                });
              },
              child: Container(
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
                child: NavigationRail(
                  extended: extended,
                  selectedIndex: _selectedTab,
                  onDestinationSelected: (index) {
                    if (index == 4) {
                      logout();
                    } else {
                      setState(() {
                        _selectedTab = index;
                      });
                    }
                  },
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20), // Padding at the top
                      const Icon(Icons.water_drop_outlined, color: tBlue),
                      if (extended) // Only show the text if the rail is extended
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('WaterWise+',
                              style: TextStyle(
                                  fontFamily: 'Quicksand', color: tBlue)),
                        ),
                    ],
                  ),
                  selectedIconTheme: const IconThemeData(color: tBlue),
                  selectedLabelTextStyle: const TextStyle(color: tBlue),
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.home_filled), label: Text("Users")),
                    NavigationRailDestination(
                        icon: Icon(Icons.map), label: Text("Bill")),
                    NavigationRailDestination(
                        icon: Icon(Icons.person_2), label: Text("Devices")),
                    NavigationRailDestination(
                        icon: Icon(Icons.logout), label: Text("Logout")),
                  ],
                ),
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
