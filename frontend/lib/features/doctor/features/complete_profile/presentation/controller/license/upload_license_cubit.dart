import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/license/upload_license_state.dart';

class UploadLicenseCubit extends Cubit<UploadLicenseState> {
  UploadLicenseCubit(this._repo) : super(const UploadLicenseState());

  final DoctorCompleteProfileRepo _repo;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickLicenseFile() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );

    if (pickedFile == null) {
      return;
    }

    final fileSizeBytes = await pickedFile.length();
    const maxFileSizeBytes = 4 * 1024 * 1024;

    if (fileSizeBytes > maxFileSizeBytes) {
      emit(
        state.copyWith(
          errorMessage: 'File must be less than or equal to 4MB',
          clearError: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        licenseFile: pickedFile,
        fileSizeKb: (fileSizeBytes / 1024).ceil(),
        clearError: true,
        isSuccess: false,
      ),
    );
  }

  void removeSelectedFile() {
    emit(
      state.copyWith(
        clearFile: true,
        clearError: true,
        isSuccess: false,
      ),
    );
  }

  Future<void> submitLicense() async {
    if (state.licenseFile == null || state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        isSuccess: false,
        clearError: true,
      ),
    );

    final result = await _repo.completeLicense(
      filePath: state.licenseFile!.path,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: false,
            errorMessage: error.message,
          ),
        );
      },
      (message) {
        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: true,
          ),
        );
      },
    );
  }
}
