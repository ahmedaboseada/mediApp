import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/repo/manage_meds/manage_meds_repo.dart';

part 'mange_meds_state.dart';

class ManageMedsCubit extends Cubit<ManageMedsState> {
  ManageMedsCubit(this._repository) : super(const ManageMedsState());

  final ManageMedsRepo _repository;

  Future<Either<ApiError, String>> addMedication({
    required String patientId,
    required String name,
    required String type,
    required String dosage,
    required String frequency,
    String? recipientFcmToken,
    List<String>? daily,
    List<Map<String, dynamic>>? weekly,
    List<Map<String, dynamic>>? specific,
  }) async {
    emit(state.copyWith(status: ManageMedsStatus.loading, clearError: true));

    final result = await _repository.addMedication(
      patientId: patientId,
      name: name,
      type: type,
      dosage: dosage,
      frequency: frequency,
      recipientFcmToken: recipientFcmToken,
      daily: daily,
      weekly: weekly,
      specific: specific,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: ManageMedsStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (message) {
        emit(
          state.copyWith(
            status: ManageMedsStatus.success,
            message: message,
            clearError: true,
          ),
        );
      },
    );

    return result;
  }

  Future<Either<ApiError, String>> updateMedication({
    required String medicationId,
    required String patientId,
    String? name,
    String? type,
    String? dosage,
    String? frequency,
    String? recipientFcmToken,
    List<String>? daily,
    List<Map<String, dynamic>>? weekly,
    List<Map<String, dynamic>>? specific,
    String? instructions,
  }) async {
    emit(state.copyWith(status: ManageMedsStatus.loading, clearError: true));

    final result = await _repository.updateMedication(
      medicationId: medicationId,
      patientId: patientId,
      name: name,
      type: type,
      dosage: dosage,
      frequency: frequency,
      recipientFcmToken: recipientFcmToken,
      daily: daily,
      weekly: weekly,
      specific: specific,
      instructions: instructions,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: ManageMedsStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (message) {
        emit(
          state.copyWith(
            status: ManageMedsStatus.success,
            message: message,
            clearError: true,
          ),
        );
      },
    );

    return result;
  }

  Future<Either<ApiError, String>> deleteMedication({
    required String medicationId,
    required String patientId,
    required String deletedMedicationName,
    String? recipientFcmToken,
  }) async {
    emit(state.copyWith(status: ManageMedsStatus.loading, clearError: true));

    final result = await _deleteMedicationFromRepository(
      medicationId: medicationId,
      patientId: patientId,
      deletedMedicationName: deletedMedicationName,
      recipientFcmToken: recipientFcmToken,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: ManageMedsStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (message) {
        emit(
          state.copyWith(
            status: ManageMedsStatus.success,
            message: message,
            clearError: true,
          ),
        );
      },
    );

    return result;
  }

  Future<Either<ApiError, String>> _deleteMedicationFromRepository({
    required String medicationId,
    required String patientId,
    required String deletedMedicationName,
    String? recipientFcmToken,
  }) {
    return _repository.deleteMedication(
      medicationId: medicationId,
      patientId: patientId,
      deletedMedicationName: deletedMedicationName,
      recipientFcmToken: recipientFcmToken,
    );
  }

  void resetState() {
    emit(const ManageMedsState());
  }
}
