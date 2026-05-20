import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  const UserModel({
    required this.id,
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.twoFA,
    required this.profilePicture,
    required this.confirmed,
    this.gender,
    this.dob,
    this.age,
    this.phone,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String firstName;
  @HiveField(3)
  final String lastName;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final bool twoFA;
  @HiveField(6)
  final String profilePicture;
  @HiveField(7)
  final bool confirmed;
  @HiveField(8)
  final String? gender;
  @HiveField(9)
  final String? dob;
  @HiveField(10)
  final int? age;
  @HiveField(11)
  final String? phone;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      twoFA: json['twoFA'] as bool? ?? false,
      profilePicture: (json['profilePicture'] ?? '').toString(),
      confirmed: json['confirmed'] as bool? ?? false,
      gender: json['gender']?.toString(),
      dob: json['DOB']?.toString(),
      age: json['age'] as int?,
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      if (gender != null) 'gender': gender,
      'twoFA': twoFA,
      'profilePicture': profilePicture,
      'confirmed': confirmed,
      if (dob != null) 'DOB': dob,
      if (age != null) 'age': age,
      if (phone != null) 'phone': phone,
    };
  }
}
