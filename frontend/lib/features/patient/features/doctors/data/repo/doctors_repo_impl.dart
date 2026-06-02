import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/data/local/booking_local_data_source.dart';
import 'package:medi/core/data/local/doctors_local_data_source.dart';
import 'package:medi/core/data/sync/sync_service.dart';
import 'package:medi/features/patient/features/doctors/data/models/booking_model.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  final ApiService apiService;
  final BookingLocalDataSource _bookingLocal = BookingLocalDataSource();
  final DoctorsLocalDataSource _doctorsLocal = DoctorsLocalDataSource();
  final NotificationDispatchService _notificationDispatchService =
      NotificationDispatchService();

  DoctorsRepositoryImpl(this.apiService);

  Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }

  List<BookingModel> _parseBookings(dynamic payload) {
    final root = _asStringKeyedMap(payload);
    final rawList = root?['bookings'];
    if (rawList is! List) return <BookingModel>[];
    return rawList
        .whereType<Map>()
        .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  bool _isOfflineFailure(ApiError error) {
    final message = error.message.toLowerCase();
    return message.contains('no internet') ||
        message.contains('internet connection') ||
        message.contains('connection timeout') ||
        message.contains('connection to server failed') ||
        message.contains('socketexception') ||
        message.contains('unexpected error occurred');
  }

  bool _isOfflineException(DioException error) {
    final message = error.message?.toLowerCase() ?? '';
    final errorText = error.error?.toString().toLowerCase() ?? '';
    return message.contains('no internet') ||
        message.contains('internet connection') ||
        message.contains('connection timeout') ||
        message.contains('connection to server failed') ||
        message.contains('socketexception') ||
        errorText.contains('socketexception') ||
        errorText.contains('failed host lookup') ||
        errorText.contains('network is unreachable') ||
        errorText.contains('connection refused');
  }

  @override
  Future<Either<ApiError, List<Doctordata>>> getGlobalDoctors() async {
    try {
      final dynamic response = await apiService.get('/doctors/directory');
      log('Get Doctors Response: ${response.toString()}');

      if (response is ServerFailure) return Left(response);

      final root = _asStringKeyedMap(response);
      final List<dynamic> rawList = root?['doctors'] ?? [];
      final doctors = rawList
          .whereType<Map>()
          .map((item) => Doctordata.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      final rawAsMaps = rawList.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      await _doctorsLocal.saveGlobalDoctors(rawAsMaps);

      return Right(doctors);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<List<Doctordata>> getCachedGlobalDoctors() async {
    try {
      return await _doctorsLocal.getGlobalDoctors();
    } catch (_) {
      return <Doctordata>[];
    }
  }

  @override
  Future<Either<ApiError, List<String>>> getDoctorSlots(String doctorId, String date) async {
    try {
      final encodedDate = Uri.encodeQueryComponent(date);
      final dynamic response = await apiService.get('/bookings/slots/$doctorId?date=$encodedDate');
      log('Get Doctor Slots Response: ${response.toString()}');

      if (response is ServerFailure) return Left(response);

      final root = _asStringKeyedMap(response);
      final List<dynamic> slots = root?['slots'] ?? [];
      return Right(slots.map((e) => e.toString()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    final payload = Map<String, dynamic>.from(bookingData);
    try {
      final dynamic response = await apiService.post('/bookings', payload);
      log('Create Booking Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          await _bookingLocal.appendBooking(payload: payload);
          await SyncService.addToQueue(type: 'add', entity: 'booking', data: payload);
          return Right('Saved locally. Will sync when online.');
        }
        return Left(response);
      }

      if (response is Map) {
        await _bookingLocal.appendBooking(payload: response.cast<String, dynamic>());
      }

      return Right(response);
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        await _bookingLocal.appendBooking(payload: payload);
        await SyncService.addToQueue(type: 'add', entity: 'booking', data: payload);
        return Right('Saved locally. Will sync when online.');
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<BookingModel>>> getPatientBookings() async {
    try {
      final dynamic response = await apiService.get('/bookings/patient');
      log('Get Patient Bookings Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          final cached = await _bookingLocal.getBookingsResponse();
          return Right(_parseBookings(cached));
        }
        return Left(response);
      }

      await _bookingLocal.saveBookingsResponse(response);
      return Right(_parseBookings(response));
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        final cached = await _bookingLocal.getBookingsResponse();
        return Right(_parseBookings(cached));
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> cancelBooking(String bookingId, String reason) async {
    final payload = {'id': bookingId, 'cancelledReason': reason, 'status': 'cancelled'};
    try {
      final dynamic response = await apiService.patch('/bookings/$bookingId/cancel', {'cancelledReason': reason});
      log('Cancel Booking Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          await _bookingLocal.updateBooking(payload: payload);
          await SyncService.addToQueue(type: 'delete', entity: 'booking', data: payload);
          return const Right(null);
        }
        return Left(response);
      }

      await _bookingLocal.updateBooking(payload: payload);
      return const Right(null);
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        await _bookingLocal.updateBooking(payload: payload);
        await SyncService.addToQueue(type: 'delete', entity: 'booking', data: payload);
        return const Right(null);
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> rescheduleBooking(String bookingId, String date, String time) async {
    final payload = {'id': bookingId, 'date': date, 'time': time};
    try {
      final dynamic response = await apiService.patch('/bookings/$bookingId/reschedule', {'date': date, 'time': time});
      log('Reschedule Booking Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          await _bookingLocal.updateBooking(payload: payload);
          await SyncService.addToQueue(type: 'update', entity: 'booking', data: payload);
          return const Right(null);
        }
        return Left(response);
      }

      await _bookingLocal.updateBooking(payload: payload);
      return const Right(null);
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        await _bookingLocal.updateBooking(payload: payload);
        await SyncService.addToQueue(type: 'update', entity: 'booking', data: payload);
        return const Right(null);
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> createReview(String doctorId, int rating, ) async {
    try {
      final payload = <String, dynamic>{'doctorId': doctorId, 'rating': rating};

      final dynamic response = await apiService.post('/reviews', payload);
      log('Create Review Response: ${response.toString()}');

      if (response is ServerFailure) return Left(response);

      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> sendConnectionRequest(
    String doctorId, {
    String? recipientFcmToken,
  }) async {
    try {
      final response = await apiService.post('/patients/connect-doctor', {'doctorId': doctorId});
      log('sendConnectionRequest response: $response');
      if (response is ServerFailure) return Left(response);

      if (recipientFcmToken != null && recipientFcmToken.trim().isNotEmpty) {
        final notificationResult = await _notificationDispatchService.sendDoctorRequestToPatient(
          recipientFcmToken: recipientFcmToken,
          recipientUserId: doctorId,
          entityId: doctorId,
        );
        notificationResult.fold(
          (error) => log('Patient->Doctor notification failed: ${error.message}'),
          (message) => log('Patient->Doctor notification sent: $message'),
        );
      } else {
        log('Patient->Doctor notification skipped: missing recipientFcmToken for $doctorId');
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> cancelConnectionRequest(String doctorId) async {
    try {
      final dynamic response = await apiService.patch('/patients/connected-doctors/cancel/$doctorId', {});
      log('Cancel Connection Request Response: ${response.toString()}');
      if (response is ServerFailure) return Left(response);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<Doctordata>>> getConnectedDoctors() async {
    try {
      final dynamic response = await apiService.get('/patients/connected-doctors');
      log('Get Connected Doctors Response: ${response.toString()}');

      if (response is ServerFailure) return Left(response);

      final root = _asStringKeyedMap(response);
      final List<dynamic> rawList = root?['doctors'] ?? [];
      final doctors = rawList
          .whereType<Map>()
          .map((item) => Doctordata.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      final rawAsMaps = rawList.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      await _doctorsLocal.saveConnectedDoctors(rawAsMaps);

      return Right(doctors);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<List<Doctordata>> getCachedConnectedDoctors() async {
    try {
      return await _doctorsLocal.getConnectedDoctors();
    } catch (_) {
      return <Doctordata>[];
    }
  }
}