import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

class BookingModel extends Equatable {
  final String id;
  final String patientId;
  final DoctorModel doctor;
  final BookingDate date;
  final int duration;
  final String packageType;
  final String bookingFor;
  final int patientAge;
  final String patientGender;
  final String problem;
  final String paymentMethod;
  final double price;
  final String status;
  final String clinicAddress;
  final String appointmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingModel({
    required this.id,
    required this.patientId,
    required this.doctor,
    required this.date,
    required this.duration,
    required this.packageType,
    required this.bookingFor,
    required this.patientAge,
    required this.patientGender,
    required this.problem,
    required this.paymentMethod,
    required this.price,
    required this.status,
    required this.clinicAddress,
    required this.appointmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['_id'] ?? '').toString(),
      patientId: (json['patientId'] ?? '').toString(),
      doctor: DoctorModel.fromJson(json['doctorId'] is Map ? json['doctorId'] : {}),
      date: BookingDate.fromJson(json['date'] is Map ? json['date'] : {}),
      duration: int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
      packageType: (json['packageType'] ?? '').toString(),
      bookingFor: (json['bookingFor'] ?? '').toString(),
      patientAge: int.tryParse(json['patientAge']?.toString() ?? '0') ?? 0,
      patientGender: (json['patientGender'] ?? '').toString(),
      problem: (json['problem'] ?? '').toString(),
      paymentMethod: (json['paymentMethod'] ?? '').toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      status: (json['status'] ?? '').toString(),
      clinicAddress: (json['clinicAddress'] ?? '').toString(),
      appointmentId: (json['appointmentId'] ?? '').toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        doctor,
        date,
        duration,
        packageType,
        bookingFor,
        patientAge,
        patientGender,
        problem,
        paymentMethod,
        price,
        status,
        clinicAddress,
        appointmentId,
        createdAt,
        updatedAt,
      ];
}

class BookingDate extends Equatable {
  final DateTime date;
  final String time;

  const BookingDate({required this.date, required this.time});

  factory BookingDate.fromJson(Map<String, dynamic> json) {
    return BookingDate(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      time: (json['time'] ?? '').toString(),
    );
  }

  @override
  List<Object?> get props => [date, time];
}
