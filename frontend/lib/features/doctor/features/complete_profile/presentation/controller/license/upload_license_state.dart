import 'package:image_picker/image_picker.dart';

class UploadLicenseState {
  const UploadLicenseState({
    this.licenseFile,
    this.fileSizeKb,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final XFile? licenseFile;
  final int? fileSizeKb;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  UploadLicenseState copyWith({
    XFile? licenseFile,
    int? fileSizeKb,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
    bool clearFile = false,
  }) {
    return UploadLicenseState(
      licenseFile: clearFile ? null : (licenseFile ?? this.licenseFile),
      fileSizeKb: clearFile ? null : (fileSizeKb ?? this.fileSizeKb),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
