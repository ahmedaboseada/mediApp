import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/cubit/doctor_complete_profile_state.dart';

class DoctorCompleteProfileCubit extends Cubit<DoctorCompleteProfileState> {
  DoctorCompleteProfileCubit(this._repo)
    : super(DoctorCompleteProfileInitial());

  final DoctorCompleteProfileRepo _repo;

  Future<void> completeStep1({
    required String specialization,
    required String clinicName,
    required String medicalLicenseId,
    required String phone,
    required String gender,
    File? profilePicture,
  }) async {
    emit(DoctorCompleteProfileLoading());

    final result = await _repo.completeStep1(
      specialization: specialization,
      clinicName: clinicName,
      medicalLicenseId: medicalLicenseId,
      phone: phone,
      gender: gender,
      profilePicture: profilePicture,
    );

    result.fold(
      (failure) => emit(DoctorCompleteProfileFailure(failure.message)),
      (message) => emit(DoctorCompleteProfileSuccess(message)),
    );
  }
}
