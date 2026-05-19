import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/core/network/api_exceptions.dart';
import 'package:medi/core/state/caregiver_mode_cubit.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';

class ManagedPatientDashboardState extends Equatable {
  const ManagedPatientDashboardState({
    this.isLoading = false,
    this.profile,
    this.error,
  });

  final bool isLoading;
  final AuthResponseModel? profile;
  final String? error;

  bool get hasProfile => profile != null;

  ManagedPatientDashboardState copyWith({
    bool? isLoading,
    AuthResponseModel? profile,
    String? error,
  }) {
    return ManagedPatientDashboardState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, profile, error];
}

class ManagedPatientDashboardCubit extends Cubit<ManagedPatientDashboardState> {
  ManagedPatientDashboardCubit(this._apiService, this._caregiverModeCubit)
      : super(const ManagedPatientDashboardState());

  final ApiService _apiService;
  final CaregiverModeCubit _caregiverModeCubit;

  Future<void> loadManagedPatientData() async {
    final patientUserId = _caregiverModeCubit.currentManagingPatientUserId;
    if (patientUserId == null) {
      emit(const ManagedPatientDashboardState());
      return;
    }

    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final dynamic response = await _apiService.get('/patient/all-data');

      if (response is ServerFailure) {
        emit(state.copyWith(isLoading: false, error: response.message));
        return;
      }

      final profile = AuthResponseModel.fromManagedPatientAllData(
        response as Map<String, dynamic>,
      );

      emit(
        ManagedPatientDashboardState(
          isLoading: false,
          profile: profile,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void clear() {
    emit(const ManagedPatientDashboardState());
  }
}