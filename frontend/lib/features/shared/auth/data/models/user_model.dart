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
  });

  final String id;
  final String type;
  final String firstName;
  final String lastName;
  final String email;
  final bool twoFA;
  final String profilePicture;
  final bool confirmed;

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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'twoFA': twoFA,
      'profilePicture': profilePicture,
      'confirmed': confirmed,
    };
  }
}
