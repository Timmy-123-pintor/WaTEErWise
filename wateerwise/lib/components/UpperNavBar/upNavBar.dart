// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../../screens/alert.dart';
import '../../screens/mainpage.dart';
import '../../screens/profile.dart';
import '../../screens/wBill.dart';
import '../../screens/wLimit.dart';

class UpTabBar extends StatefulWidget {
  const UpTabBar({super.key});

  @override
  State<UpTabBar> createState() => _UpTabBarState();
}

class _UpTabBarState extends State<UpTabBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final double appBarHeight = 37 / devicePixelRatio;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          backgroundColor: tBlue,
          elevation: 0.0,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: 34,
              width: double.infinity,
              color: tBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/waterlogo.png',
                      width: 33,
                      height: 33,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'WaterWise+',
                      style: GoogleFonts.quicksand(
                        textStyle: waterStyle,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Handle logout action
                      },
                      child: Image.asset(
                        'assets/images/logout.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  color: tBlue,
                )
              ],
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: tBlue,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, right: 15, left: 15),
                  child: TabBar(
                    unselectedLabelColor: tWhite,
                    labelColor: tBlue,
                    controller: tabController,
                    indicator: const BoxDecoration(
                      color: tWG,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                    ),
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    tabs: [
                      Tab(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/home.png',
                              width: 24,
                              height: 24,
                              color: selectedIndex == 0 ? tBlue : tWhite,
                            ),
                            Text(
                              'Home',
                              style: GoogleFonts.quicksand(
                                textStyle: navText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/wlimit.png',
                              width: 24,
                              height: 24,
                              color: selectedIndex == 1 ? tBlue : tWhite,
                            ),
                            Text(
                              'W-Limit',
                              style: GoogleFonts.quicksand(
                                textStyle: navText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/wbill.png',
                              width: 24,
                              height: 24,
                              color: selectedIndex == 2 ? tBlue : tWhite,
                            ),
                            Text(
                              'W-Bill',
                              style: GoogleFonts.quicksand(
                                textStyle: navText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/alert.png',
                              width: 24,
                              height: 24,
                              color: selectedIndex == 3 ? tBlue : tWhite,
                            ),
                            Text(
                              'Alert',
                              style: GoogleFonts.quicksand(
                                textStyle: navText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/profile.png',
                              width: 24,
                              height: 24,
                              color: selectedIndex == 4 ? tBlue : tWhite,
                            ),
                            Text(
                              'Profile',
                              style: GoogleFonts.quicksand(
                                textStyle: navText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  MainPage(),
                  WLimit(),
                  WBill(),
                  Alert(),
                  Profile(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
