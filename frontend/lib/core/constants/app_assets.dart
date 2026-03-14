class AppAssets {
  static const String path = 'assets/images/';
  static const String svgPath = 'assets/svg/';
  static const String medication = '${path}medication.svg';
  static const String doctors = '${path}doctors.svg';
  static const String progress = '${path}progress.svg';
  static const String sticker = '${path}Sticker.svg';
  static const String group8 = '${path}Group (8).svg';
  static const String welcomPng = '${path}welcom.png';
  static const String welcomSvg = '${path}welcom.svg';
  static const String doctor = '${path}doctor.svg';
  static const String patient = '${path}patient.svg';
  static const String tablets = '${path}tablets.png';
  static const String updatePassword = '${path}updatePassword.svg';
  static const String completeProfile = '${path}completeProfile.png';
  static const String addInfo = '${path}add_info.png';
  static const String avatar1 = '${path}person1.png';
  static const String avatar2 = '${path}person2.png';
  static const String avatar3 = '${path}person3.png';
  static const String lineEdit = '${path}line_edit.svg';
  static const String calendar = '${path}calendar.svg';
  static const String chats = '${path}chats.svg';
  static const String connectedDoctors = '${path}connected_doctors.svg';
  static const String profile = '${path}profile.svg';
  static const String docs = '${path}docs.svg';
  static const String home = '${path}home.svg';
  static const String dollar = '${path}dollar.svg';
  static const String notification = '${path}notification.svg';
  static const String notifications = '${path}notifications.svg';
  static const String settings = '${path}settings.svg';
  static const String stethoscope = '${path}stethoscope.svg';
  static const String allowNotification = '${path}allow_notification.png';
  static const String apple = '${path}apple.svg';
  static const String google = '${path}google.svg';
  static const String facebook = '${path}facebook.svg';
  static const String man = '${path}man.svg';
  static const String manual = '${path}manual.svg';
  static const String ocr = '${path}ocr.svg';
  static const String barcode = '${path}barcode.svg';
  static const String ringtone = '${path}ringtone.png';
  static const String support = '${path}support.svg';
  static const String switchAccount = '${path}switch_account.svg';
  static const String pills = '${path}pills.svg';
  static const String export = '${path}export.svg';
  static const String tablerEdit = '${path}tabler_edit.svg';
  static const String bloodPressure = '${path}hugeicons_blood-pressure.svg';
  static const String edit = '${path}edit.svg';

  // Health measurement icons
  static const String bloodPressureIcon = '${svgPath}blood_pressure.svg';
  static const String bloodSugarIcon = '${svgPath}blood_sugar.svg';
  static const String heartRateIcon = '${svgPath}heart_rate.svg';
  static const String weightScaleIcon = '${svgPath}weight_scale.svg';
  static const String statusNormalIcon = '${svgPath}status_normal.svg';

  // Medicine item icons
  static const String heartRate = '${path}heartrate.svg';
  static const String injection = '${path}injection.png';
  static const String tabletIcon = '${path}tablet.png';
  static const String medicineBox = '${path}box.svg';
  static const String medicineDrop = '${path}drop.svg';
  static const String medicineCream = '${path}cream.svg';
  static const String medicineOintment = '${path}ointment.svg';
  static const String medicineInhaler = '${path}inhaler.svg';

  // Helper method to get medicine icon by type
  static String getMedicineIcon(dynamic medicationType) {
    // Import required: import 'package:medi/features/patient/features/add_medication/presentation/models/medication.dart';
    final typeStr = medicationType.toString().split('.').last;

    return switch (typeStr) {
      'pill' => medicineBox,
      'syringe' => injection,
      'bottle' => medicineBox,
      'tablet' => tabletIcon,
      'cream' => medicineCream,
      'drop' => medicineDrop,
      'inhaler' => medicineInhaler,
      'ointment' => medicineOintment,
      _ => tabletIcon, // default
    };
  }
}
