import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/profile/data/models/caregiver_request_model.dart';
import 'package:medi/features/patient/features/profile/data/models/doctor_request_model.dart';
import 'package:medi/features/patient/features/profile/data/models/managed_patient_summary.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ChangePasswordLoading());

    final result = await profileRepo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(ChangePasswordFailure(failure.message, failure.errors)),
      (message) => emit(ChangePasswordSuccess(message)),
    );
  }

  Future<void> requestEmailChange({required String newEmail}) async {
    emit(RequestEmailChangeLoading());

    final result = await profileRepo.requestEmailChange(newEmail: newEmail);

    result.fold(
      (failure) =>
          emit(RequestEmailChangeFailure(failure.message, failure.errors)),
      (message) => emit(RequestEmailChangeSuccess(message)),
    );
  }

  Future<void> cancelEmailChange() async {
    emit(CancelEmailChangeLoading());

    final result = await profileRepo.cancelEmailChange();

    result.fold(
      (failure) =>
          emit(CancelEmailChangeFailure(failure.message, failure.errors)),
      (message) => emit(CancelEmailChangeSuccess(message)),
    );
  }

  Future<void> confirmEmailChange({
    required String confirmEmailChangeToken,
  }) async {
    emit(ConfirmEmailChangeLoading());

    final result = await profileRepo.confirmEmailChange(
      confirmEmailChangeToken: confirmEmailChangeToken,
    );

    result.fold(
      (failure) =>
          emit(ConfirmEmailChangeFailure(failure.message, failure.errors)),
      (message) => emit(ConfirmEmailChangeSuccess(message)),
    );
  }

  Future<void> toggleTwoFactorAuth(bool enabled) async {
    emit(ToggleTwoFactorAuthLoading());

    final result = await profileRepo.toggleTwoFactorAuth(enabled);

    result.fold(
      (failure) =>
          emit(ToggleTwoFactorAuthFailure(failure.message, failure.errors)),
      (message) => emit(ToggleTwoFactorAuthSuccess(message)),
    );
  }

  Future<void> listCaregiverRequests() async {
    emit(CaregiverRequestsLoading());

    final result = await profileRepo.listCaregiverRequests();

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(CaregiverRequestsFailure(failure.message, failure.errors)),
      (requests) => emit(CaregiverRequestsSuccess(requests)),
    );
  }

  Future<void> listManagedPatients() async {
    emit(ManagedPatientsLoading());

    final result = await profileRepo.listManagedPatients();

    if (isClosed) return;

    result.fold(
      (failure) => emit(ManagedPatientsFailure(failure.message, failure.errors)),
      (patients) => emit(ManagedPatientsSuccess(patients)),
    );
  }

  Future<void> acceptCaregiverRequest({required String requestId}) async {
    emit(CaregiverRequestActionLoading());

    final result = await profileRepo.acceptCaregiverRequest(
      requestId: requestId,
    );

    await result.fold(
      (failure) async {
        emit(CaregiverRequestActionFailure(failure.message, failure.errors));
      },
      (message) async {
        emit(CaregiverRequestActionSuccess(message));
        await listCaregiverRequests();
      },
    );
  }

  Future<void> rejectCaregiverRequest({required String requestId}) async {
    emit(CaregiverRequestActionLoading());

    final result = await profileRepo.rejectCaregiverRequest(
      requestId: requestId,
    );

    await result.fold(
      (failure) async {
        emit(CaregiverRequestActionFailure(failure.message, failure.errors));
      },
      (message) async {
        emit(CaregiverRequestActionSuccess(message));
        await listCaregiverRequests();
      },
    );
  }

  Future<void> listDoctorRequests() async {
    emit(DoctorRequestsLoading());

    final result = await profileRepo.listDoctorRequests();

    result.fold(
      (failure) => emit(DoctorRequestsFailure(failure.message, failure.errors)),
      (requests) => emit(DoctorRequestsSuccess(requests)),
    );
  }

  Future<void> acceptDoctorRequest({
    required String doctorId,
    String? doctorFcmToken,
  }) async {
    emit(DoctorRequestActionLoading());

    final result = await profileRepo.acceptDoctorRequest(
      doctorId: doctorId,
      doctorFcmToken: doctorFcmToken,
    );

    await result.fold(
      (failure) async {
        emit(DoctorRequestActionFailure(failure.message, failure.errors));
      },
      (message) async {
        emit(DoctorRequestActionSuccess(message));
        await listDoctorRequests();
      },
    );
  }

  Future<void> rejectDoctorRequest({required String doctorId}) async {
    emit(DoctorRequestActionLoading());

    final result = await profileRepo.rejectDoctorRequest(doctorId: doctorId);

    await result.fold(
      (failure) async {
        emit(DoctorRequestActionFailure(failure.message, failure.errors));
      },
      (message) async {
        emit(DoctorRequestActionSuccess(message));
        await listDoctorRequests();
      },
    );
  }
}
