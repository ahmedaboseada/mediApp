import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/data/models/doctor_appointment_model.dart';
import 'package:medi/features/doctor/features/home/data/repo/appointments_repository.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  AppointmentsRepositoryImpl(this.apiService, {this.useMockData = true});

  final ApiService apiService;
  final bool useMockData;

  @override
  Future<Either<ApiError, List<DoctorAppointmentModel>>> getAppointmentsForDate(
    DateTime date,
  ) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final dynamic response = await apiService.get(
        '${ApiEndpoints.doctorAppointments}?date=$formattedDate',
      );

      log('Get Appointments Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (useMockData) {
          return Right(_mockAppointmentsFor(date));
        }
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

      if (useMockData && appointments.isEmpty) {
        return Right(_mockAppointmentsFor(date));
      }

      return Right(appointments);
    } on DioException catch (e) {
      if (useMockData) {
        return Right(_mockAppointmentsFor(date));
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      if (useMockData) {
        return Right(_mockAppointmentsFor(date));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  List<DoctorAppointmentModel> _mockAppointmentsFor(DateTime date) {
    final day = date.day;

    return [
      DoctorAppointmentModel(
        name: 'Mai Ali',
        visitTime: day.isEven ? '01:30 PM' : '09:30 AM',
        avatarAsset: AppAssets.avatar1,
      ),
      DoctorAppointmentModel(
        name: 'Reem Saad',
        visitTime: day.isEven ? '01:45 PM' : '10:00 AM',
        avatarAsset: AppAssets.avatar2,
      ),
      DoctorAppointmentModel(
        name: 'Ali Sayed',
        visitTime: day.isEven ? '02:00 PM' : '10:30 AM',
        avatarAsset: AppAssets.avatar3,
      ),
      DoctorAppointmentModel(
        name: 'Mona Ali',
        visitTime: day.isEven ? '02:15 PM' : '11:00 AM',
        avatarAsset: AppAssets.avatar2,
      ),
    ];
  }

  List<dynamic> _extractItems(dynamic response) {
    if (response is List) {
      return response;
    }

    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is List) {
        return data;
      }

      final appointments = response['appointments'];
      if (appointments is List) {
        return appointments;
      }
    }

    return const [];
  }
}
