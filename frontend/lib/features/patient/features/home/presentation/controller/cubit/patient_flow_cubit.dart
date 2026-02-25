import 'package:flutter_bloc/flutter_bloc.dart';

enum PatientTab { home, medicine, doctor, chat, profile }

class PatientFlowCubit extends Cubit<PatientTab> {
  PatientFlowCubit() : super(PatientTab.home);
  void changeTab(PatientTab tab) => emit(tab);
}
