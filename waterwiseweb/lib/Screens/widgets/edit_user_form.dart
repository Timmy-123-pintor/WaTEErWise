// edit_user_form.dart

import 'package:flutter/material.dart';
import 'package:waterwiseweb/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserForm extends StatefulWidget {
  final UserModel user;

  const EditUserForm({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserFormState createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _locationController;
  late TextEditingController _deviceNameController;
  final List<String> locations = [
    'Sitio Oregano, Lawaan II',
    'Sitio Gumamela, Lawaan II',
    'Sitio Puso-an, Lawaan II',
    'Sitio Gangan, Lawaan II',
    'Sitio Luy-a, Lawaan II',
    'Sitio Lemoncito, Lawaan II',
    'Sitio Sombria, Lawaan II',
    'Sitio Manga, Lawaan II',
    'Sitio Kaimito, Lawaan II',
  ];
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _locationController = TextEditingController(text: widget.user.location);
    _deviceNameController = TextEditingController(text: widget.user.deviceName);
    selectedLocation =
        locations.contains(widget.user.location) ? widget.user.location : null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _locationController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation = newValue;
                    _locationController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a location';
                  }
                  return null;
                },
                items:
                    locations.map<DropdownMenuItem<String>>((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _deviceNameController,
                decoration: const InputDecoration(labelText: 'Device Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a device name';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveUser();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUser() async {
    // This is where you would call your backend service to update the user
    // For Firebase Firestore, it would look something like this:

    final collection = FirebaseFirestore.instance.collection('users');
    await collection
        .doc(widget.user.uid)
        .update({
          'email': _emailController.text.trim(),
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'location': _locationController.text.trim(),
          'deviceName': _deviceNameController.text.trim(),
          // Update other fields as needed
        })
        .then((_) => Navigator.of(context).pop()) // Close the form on success
        .catchError((error) {
          // Handle errors, e.g. by displaying a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating user: $error')),
          );
        });
  }
}
