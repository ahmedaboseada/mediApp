import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/data/models/doctor_appointment_model.dart';
import 'package:medi/features/doctor/features/home/data/repo/appointments_repository.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  AppointmentsRepositoryImpl(this.apiService);

  final ApiService apiService;

  @override
  Future<Either<ApiError, List<DoctorAppointmentModel>>> getAppointmentsForDate(
    DateTime date,
  ) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final dynamic response = await apiService.get(
        '/bookings/doctor?date=$formattedDate',
      );

      log('Get Appointments Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final List<dynamic> rawList = _extractItems(response);
      final appointments = rawList
          .whereType<Map>()
          .map(
            (item) => DoctorAppointmentModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      return Right(appointments);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  List<dynamic> _extractItems(dynamic response) {
    if (response is List) return response;
    if (response is Map) {
      if (response.containsKey('bookings')) return response['bookings'];
      if (response.containsKey('appointments')) return response['appointments'];
      if (response.containsKey('data')) return _extractItems(response['data']);
    }
    return [];
  }
}
