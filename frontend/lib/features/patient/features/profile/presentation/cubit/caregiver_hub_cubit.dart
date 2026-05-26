import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/profile/data/models/caregiver_request_model.dart';
import 'package:medi/features/patient/features/profile/data/models/managed_patient_summary.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';

class CaregiverHubState extends Equatable {
  const CaregiverHubState({
    this.isLoading = false,
    this.isActionLoading = false,
    this.requests = const <CaregiverRequestModel>[],
    this.managedPatients = const <ManagedPatientSummary>[],
    this.error,
    this.message,
  });

  final bool isLoading;
  final bool isActionLoading;
  final List<CaregiverRequestModel> requests;
  final List<ManagedPatientSummary> managedPatients;
  final String? error;
  final String? message;

  CaregiverHubState copyWith({
    bool? isLoading,
    bool? isActionLoading,
    List<CaregiverRequestModel>? requests,
    List<ManagedPatientSummary>? managedPatients,
    String? error,
    String? message,
  }) {
    return CaregiverHubState(
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      requests: requests ?? this.requests,
      managedPatients: managedPatients ?? this.managedPatients,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isActionLoading,
    requests,
    managedPatients,
    error,
    message,
  ];
}

class CaregiverHubCubit extends Cubit<CaregiverHubState> {
  CaregiverHubCubit(this._profileRepo) : super(const CaregiverHubState());

  final ProfileRepo _profileRepo;

  Future<void> loadHubData() async {
    emit(state.copyWith(isLoading: true, error: null, message: null));

    final requestsResult = await _profileRepo.listCaregiverRequests();
    final patientsResult = await _profileRepo.listManagedPatients();

    if (isClosed) return;

    requestsResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (requests) => emit(state.copyWith(requests: requests)),
    );

    patientsResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (patients) => emit(
        state.copyWith(
          isLoading: false,
          managedPatients: patients,
          error: null,
        ),
      ),
    );
  }

  Future<void> acceptCaregiverRequest({required String requestId}) async {
    emit(state.copyWith(isActionLoading: true, error: null, message: null));

    final result = await _profileRepo.acceptCaregiverRequest(requestId: requestId);

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isActionLoading: false, error: failure.message)),
      (message) async {
        emit(state.copyWith(isActionLoading: false, message: message));
        await loadHubData();
      },
    );
  }

  Future<void> rejectCaregiverRequest({required String requestId}) async {
    emit(state.copyWith(isActionLoading: true, error: null, message: null));

    final result = await _profileRepo.rejectCaregiverRequest(requestId: requestId);

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isActionLoading: false, error: failure.message)),
      (message) async {
        emit(state.copyWith(isActionLoading: false, message: message));
        await loadHubData();
      },
    );
  }
}