import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchAllDevices() async {
  var response = await http.get(Uri.parse('http://localhost:3000/all-devices'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load devices');
  }
}
