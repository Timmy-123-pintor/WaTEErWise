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
}
