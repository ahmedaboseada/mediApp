import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this._authRepo) : super(const UserProfileInitial());

  final AuthRepo _authRepo;

  Future<AuthResponseModel?> _getCachedProfile() async {
    final user = await HiveService.getUserData();
    if (user == null) return null;

    final patient = await HiveService.getPatientData();
    final doctor = await HiveService.getDoctorData();

    return AuthResponseModel(
      message: 'Cached profile loaded',
      user: user,
      accessToken: '',
      refreshToken: '',
      patient: patient,
      doctor: doctor,
      rawJson: {
        'user': user.toJson(),
        if (patient != null) 'patient': patient.toJson(),
        if (doctor != null) 'doctor': doctor.toJson(),
      },
    );
  }

  Future<void> getMe() async {
    final cachedProfile = await _getCachedProfile();

    if (isClosed) return;

    if (cachedProfile != null) {
      emit(UserProfileLoaded(cachedProfile));
    } else {
      emit(const UserProfileLoading());
    }

    final result = await _authRepo.getMe();

    if (isClosed) return;

    result.fold(
      (error) {
        if (cachedProfile == null) {
          emit(UserProfileError(error.message));
        }
      },
      (profile) => emit(UserProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? dob,
    String? profilePicture,
    String? specialization,
    String? clinicName,
    String? medicalLicenseId,
  }) async {
    emit(const UserProfileLoading());

    final result = await _authRepo.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      gender: gender,
      dob: dob,
      profilePicture: profilePicture,
      specialization: specialization,
      clinicName: clinicName,
      medicalLicenseId: medicalLicenseId,
    );

    result.fold(
      (error) => emit(UserProfileError(error.message)),
      (profile) => emit(UserProfileUpdated(profile)),
    );
  }
}
