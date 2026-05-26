import 'package:flutter_bloc/flutter_bloc.dart';

class CaregiverModeCubit extends Cubit<String?> {
  CaregiverModeCubit() : super(null);

  String? get currentManagingPatientUserId => state;

  bool get isManagingPatient => state != null;

  void enterCaregiverMode(String patientUserId) {
    emit(patientUserId);
  }

  void exitCaregiverMode() {
    emit(null);
  }
}