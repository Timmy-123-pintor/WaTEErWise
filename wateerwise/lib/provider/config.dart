import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  static String get apiEndpoint {
    if (kIsWeb) {
      return 'http://localhost:3000'; 
    } else {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000';
      } else {
        return 'http://192.168.156.69:3000';
      }
    }
  }
}