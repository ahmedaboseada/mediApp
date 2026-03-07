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
      id: json['id'] as String,
      type: json['type'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      twoFA: json['twoFA'] as bool? ?? false,
      profilePicture: json['profilePicture'] as String? ?? '',
      confirmed: json['confirmed'] as bool? ?? false,
      gender: json['gender'] as String?,
      dob: json['DOB'] as String?,
      age: json['age'] as int?,
      phone: json['phone'] as String?,
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
