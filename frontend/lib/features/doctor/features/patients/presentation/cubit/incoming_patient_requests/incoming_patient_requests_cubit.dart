import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/incoming_patient_request_model.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/incoming_patient_requests/incoming_patient_requests_state.dart';

class IncomingPatientRequestsCubit extends Cubit<IncomingPatientRequestsState> {
  IncomingPatientRequestsCubit(this._apiService)
    : super(const IncomingPatientRequestsState());

  final ApiService _apiService;

  Future<void> loadRequests() async {
    emit(
      state.copyWith(
        status: IncomingPatientRequestsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final dynamic response = await _apiService.get(
        '/doctors/patients/patients-request-list',
      );
      log('Incoming patient requests response: ${response.toString()}');

      if (response is ServerFailure) {
        emit(
          state.copyWith(
            status: IncomingPatientRequestsStatus.failure,
            errorMessage: response.message,
          ),
        );
        return;
      }

      final List<dynamic> rawList = _extractList(response);
      final requests = rawList
          .whereType<Map>()
          .map(
            (item) => IncomingPatientRequestModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((item) => item.patientObjectId.isNotEmpty)
          .toList(growable: false);

      emit(
        state.copyWith(
          status: requests.isEmpty
              ? IncomingPatientRequestsStatus.empty
              : IncomingPatientRequestsStatus.success,
          requests: requests,
          clearError: true,
          clearProcessing: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: IncomingPatientRequestsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<Either<ApiError, void>> acceptRequest(
    IncomingPatientRequestModel request,
  ) async {
    return _runAction(
      request: request,
      path: '/doctors/patients/accept/${request.patientObjectId}',
    );
  }

  Future<Either<ApiError, void>> rejectRequest(
    IncomingPatientRequestModel request,
  ) async {
    return _runAction(
      request: request,
      path: '/doctors/patients/reject/${request.patientObjectId}',
    );
  }

  Future<Either<ApiError, void>> _runAction({
    required IncomingPatientRequestModel request,
    required String path,
  }) async {
    emit(
      state.copyWith(
        processingRequestId: request.patientObjectId,
        clearError: true,
      ),
    );

    try {
      final dynamic response = await _apiService.patch(path, const {});
      log('Incoming request action response: ${response.toString()}');

      if (response is ServerFailure) {
        emit(
          state.copyWith(errorMessage: response.message, clearProcessing: true),
        );
        return Left(response);
      }

      await loadRequests();
      return const Right(null);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), clearProcessing: true));
      return Left(ServerFailure(e.toString()));
    }
  }

  List<dynamic> _extractList(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response['requests'] is List)
        return response['requests'] as List<dynamic>;
      if (response['patients'] is List)
        return response['patients'] as List<dynamic>;
      if (response['data'] is List) return response['data'] as List<dynamic>;
    }

    if (response is List) {
      return response;
    }

    return const <dynamic>[];
  }
}
