import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterwiseweb/Screens/bill.dart';
import 'package:waterwiseweb/components/Devices/user_devices.dart';
import 'package:waterwiseweb/components/Dashboard/all_users_screen.dart';
import 'package:waterwiseweb/components/Registration/user_registration.dart';
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
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/EmailPasswordLoginWM', (route) => true);
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
              selectedItemColor: tWhite,
              unselectedIconTheme: const IconThemeData(color: tWhite),
              unselectedItemColor: tWhite,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: "Home",
                  backgroundColor: tBlue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: "Bill",
                  backgroundColor: tBlue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2),
                  label: "Devices",
                  backgroundColor: tBlue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_add),
                  label: "Add user",
                  backgroundColor: tBlue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout),
                  label: "Logout",
                  backgroundColor: tBlue,
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
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
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
                  backgroundColor: tBlue,
                  extended: extended,
                  selectedIndex: _selectedTab,
                  unselectedIconTheme:
                      const IconThemeData(color: Colors.white, opacity: 1),
                  unselectedLabelTextStyle:
                      const TextStyle(color: Colors.white),
                  selectedIconTheme: const IconThemeData(color: tBlue),
                  labelType: extended
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.selected,
                  destinations: [
                    ...destinations,
                  ],
                ),
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                renderView(0, const AllUsersScreen()),
                renderView(1, const Bill()),
                renderView(2, DeviceScreen()),
                renderView(3, const AddUser()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<NavigationRailDestination> destinations = [
    const NavigationRailDestination(
      icon: Icon(Icons.home_filled),
      label: Text("Users"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.map),
      label: Text("Bill"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.person_2),
      label: Text("Devices"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.person_add),
      label: Text("Add User"),
    ),
  ];

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
