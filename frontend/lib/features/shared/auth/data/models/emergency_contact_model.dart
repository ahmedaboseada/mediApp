class EmergencyContactModel {
  final String name;
  final String phone;
  final String? contactMethod;

  EmergencyContactModel({required this.name, required this.phone, this.contactMethod});

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      contactMethod: json['contactMethod']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      if (contactMethod != null) 'contactMethod': contactMethod,
    };
  }
}
