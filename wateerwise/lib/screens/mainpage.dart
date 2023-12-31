import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/Graphs/HomeGraphs/consumptionGraph.dart';
import '../components/conScreen.dart/currentBill.dart';
import '../components/conScreen.dart/prevConsumption.dart';
import '../components/conScreen.dart/waterCon.dart';
import '../constant.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

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
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ListView(
                  children: const [
                    SizedBox(
                      height: 15,
                    ),
                    WaterConsumption(),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: PrevComCon(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: CurrentBill(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConsumptionTrend(),
                    SizedBox(
                      height: 10,
                    ),
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
