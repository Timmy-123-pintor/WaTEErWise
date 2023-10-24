import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  late final DatabaseReference mainReference;
  final FirebaseDatabase _database;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseService._internal()
      : _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://waterwise-database-default-rtdb.asia-southeast1.firebasedatabase.app',
        ) {
    mainReference = _database.ref();
  }

  factory FirebaseService() {
    return _instance;
  }

  String get currentUserUid {
    return _auth.currentUser?.uid ?? '';
  }

  Future<List<Map<String, dynamic>>> fetchAllDevices() async {
    List<Map<String, dynamic>> devicesList = [];

    DataSnapshot devicesSnapshot =
        (await mainReference.child('devices').once()) as DataSnapshot;
    if (devicesSnapshot.value != null && devicesSnapshot.value is Map) {
      Map<String, dynamic> devices = Map.from(devicesSnapshot.value as Map);
      devices.forEach((key, value) {
        Map<String, dynamic> deviceData = Map.from(value as Map);
        deviceData['lYW3ZLaRV2W6pTLAussJ49PVKq6LzZrQKojEZlkf'] =
            key; // Add the Firebase node key to the device data
        devicesList.add(deviceData);
      });
    }

    return devicesList;
  }
}
