import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waterwiseweb/Screens/services/firebase_service_methods.dart';
import 'package:http/http.dart' as http;

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<Map<String, dynamic>> devices = [];

  Future<void> _renameDevice(String deviceId, String newName) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/devices/$deviceId/rename'),
      body: {
        'name': newName,
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        final device = devices.firstWhere((device) => device['id'] == deviceId);
        device['name'] = newName;
      });
    } else {
      if (kDebugMode) {
        print(
            'Failed to rename device with status code: ${response.statusCode}');
      }
    }
  }

  Future<void> _deleteDevice(String deviceId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/devices/$deviceId'),
    );

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('Failed to delete device');
      }
    } else {
      setState(() {
        // Removing the device from the list after successful deletion
        // Assuming there's a list variable holding the devices; this might need adjustment
        devices.removeWhere((device) => device['id'] == deviceId);
      });
    }
  }

  Future<void> _updateDeviceStatus(String deviceId, String newStatus) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/update-device-status'),
      body: {
        'deviceId': deviceId,
        'status': newStatus,
      },
    );

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('Failed to update device status');
      }
    }
  }

  Future<void> _showRenameDialog(String deviceId, String currentName) async {
    String? newName;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Device'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter a new name for the device:'),
                TextField(
                  onChanged: (value) {
                    newName = value;
                  },
                  decoration: InputDecoration(
                    hintText: currentName,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Rename'),
              onPressed: () {
                if (newName != null && newName!.isNotEmpty) {
                  _renameDevice(deviceId, newName!);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: fetchAllDevices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final device = snapshot.data?[index];
                  final deviceStatus = device?['status'] == 'active';
                  return ListTile(
                    title: Text(device?['name'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UID: ${device?['uid'] ?? ''}'),
                        Text(
                            'Last Seen: ${device?['lastSeen'] ?? ''}'), // Assuming 'lastSeen' is available
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: deviceStatus,
                          onChanged: (bool value) {
                            final newStatus = value ? 'active' : 'inactive';
                            _updateDeviceStatus(device?['id'] ?? '', newStatus);
                            setState(() {
                              device?['status'] = newStatus;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteDevice(device?['id'] ?? '');
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
