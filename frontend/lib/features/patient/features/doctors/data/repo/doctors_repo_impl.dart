//  implement DoctorsRepository

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/booking_model.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  final ApiService apiService;

  DoctorsRepositoryImpl(this.apiService);

  @override
  Future<Either<ApiError, List<DoctorModel>>> getGlobalDoctors() async {
    try {
      final dynamic response = await apiService.get("/doctors/directory");

      log('Get Doctors Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      // 👇 هنا بنقرأ doctors من الresponse
      final List<dynamic> rawList = response['doctors'] ?? [];

      final doctors = rawList
          .whereType<Map>()
          .map((item) => DoctorModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      return Right(doctors);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<String>>> getDoctorSlots(
    String doctorId,
    String date,
  ) async {
    try {
      final encodedDate = Uri.encodeQueryComponent(date);

      final dynamic response = await apiService.get(
        "/bookings/slots/$doctorId?date=$encodedDate",
      );

      log('Get Doctor Slots Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final List<dynamic> slots = response['slots'] ?? [];
      return Right(slots.map((e) => e.toString()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> createBooking(
    Map<String, dynamic> bookingData,
  ) async {
    try {
      final dynamic response = await apiService.post("/bookings", bookingData);

      log('Create Booking Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<BookingModel>>> getPatientBookings() async {
    try {
      final dynamic response = await apiService.get("/bookings/patient");

      log('Get Patient Bookings Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final List<dynamic> rawList = response['bookings'] ?? [];

      final bookings = rawList
          .whereType<Map>()
          .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      return Right(bookings);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> cancelBooking(
    String bookingId,
    String reason,
  ) async {
    try {
      final dynamic response = await apiService.patch(
        "/bookings/$bookingId/cancel",
        {"cancelledReason": reason},
      );

      log('Cancel Booking Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> rescheduleBooking(
    String bookingId,
    String date,
    String time,
  ) async {
    try {
      final dynamic response = await apiService.patch(
        "/bookings/$bookingId/reschedule",
        {"date": date, "time": time},
      );

      log('Reschedule Booking Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> sendConnectionRequest(String doctorId) async {
    try {
      final response = await apiService.post('/patients/connect-doctor', {
        'doctorId': doctorId,
      });

      log('sendConnectionRequest response: $response');

      if (response is ServerFailure) {
        return Left(response);
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<DoctorModel>>> getConnectedDoctors() async {
    try {
      final dynamic response = await apiService.get("/patients/connected-doctors");

      log('Get Connected Doctors Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final List<dynamic> rawList = response['doctors'] ?? [];

      final doctors = rawList
          .whereType<Map>()
          .map((item) => DoctorModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      return Right(doctors);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
