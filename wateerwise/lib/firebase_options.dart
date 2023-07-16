// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCtQMneieeAYBBHyUEAAdaMZ7LK5sBRknc',
    appId: '1:602648296786:web:d89112910b14b14ad34e8b',
    messagingSenderId: '602648296786',
    projectId: 'waterwise-database',
    authDomain: 'waterwise-database.firebaseapp.com',
    databaseURL: 'https://waterwise-database-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'waterwise-database.appspot.com',
    measurementId: 'G-S6FN15HDFH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAv9KulUybMqG88bsx4lXNZND_zv4QWnYc',
    appId: '1:602648296786:android:fd525bac52ccb0dad34e8b',
    messagingSenderId: '602648296786',
    projectId: 'waterwise-database',
    databaseURL: 'https://waterwise-database-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'waterwise-database.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrbrbr28JzbOXeak2xhanmJZX3jtS2g34',
    appId: '1:602648296786:ios:0f3615b67b447615d34e8b',
    messagingSenderId: '602648296786',
    projectId: 'waterwise-database',
    databaseURL: 'https://waterwise-database-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'waterwise-database.appspot.com',
    androidClientId: '602648296786-lug2oshth6d1dqhi3tr1bl654l43ldcf.apps.googleusercontent.com',
    iosClientId: '602648296786-trqhhia9qq694bh04idnst83f8fvggk2.apps.googleusercontent.com',
    iosBundleId: 'com.example.wateerwise',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBrbrbr28JzbOXeak2xhanmJZX3jtS2g34',
    appId: '1:602648296786:ios:7c5a826e75de695ed34e8b',
    messagingSenderId: '602648296786',
    projectId: 'waterwise-database',
    databaseURL: 'https://waterwise-database-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'waterwise-database.appspot.com',
    androidClientId: '602648296786-lug2oshth6d1dqhi3tr1bl654l43ldcf.apps.googleusercontent.com',
    iosClientId: '602648296786-4dp5bpc91lu217tsta9hc78d1cjallkc.apps.googleusercontent.com',
    iosBundleId: 'com.example.wateerwise.RunnerTests',
  );
}
