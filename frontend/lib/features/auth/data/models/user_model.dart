class UserModel {
  const UserModel({this.image, this.name, this.email, this.password});
  final String? image;
  final String? name;
  final String? email;
  final String? password;
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      image: json['image'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
    );
  }
}
