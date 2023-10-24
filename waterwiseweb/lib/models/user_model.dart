class UserModel {
  final String uid;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String location;
  final String deviceType;
  final String deviceName;
  final String deviceUID;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.deviceType,
    required this.deviceName,
    required this.deviceUID,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      role: json['role'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      location: json['location'],
      deviceType: json['deviceType'],
      deviceName: json['deviceName'],
      deviceUID: json['deviceUID'],
    );
  }
}
