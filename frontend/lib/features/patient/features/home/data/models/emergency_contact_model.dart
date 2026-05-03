class EmergencyContactModel {
  final String name;
  final String phone;
  final String contactMethod; // 'whatsapp' or 'sms'

  EmergencyContactModel({
    required this.name,
    required this.phone,
    required this.contactMethod,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      contactMethod: json['contactMethod'] ?? 'whatsapp',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'contactMethod': contactMethod};
  }
}
