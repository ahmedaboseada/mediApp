import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/add_medication/presentation/models/medication.dart';

enum MedicineTab { all, active, chronic }

class MedicineState extends Equatable {
  const MedicineState({
    required this.selectedTab,
    required this.isFabExpanded,
    required this.medications,
  });

  factory MedicineState.initial(List<Medication> medications) {
    return MedicineState(
      selectedTab: MedicineTab.all,
      isFabExpanded: false,
      medications: medications,
    );
  }

  final MedicineTab selectedTab;
  final bool isFabExpanded;
  final List<Medication> medications;

  MedicineState copyWith({
    MedicineTab? selectedTab,
    bool? isFabExpanded,
    List<Medication>? medications,
  }) {
    return MedicineState(
      selectedTab: selectedTab ?? this.selectedTab,
      isFabExpanded: isFabExpanded ?? this.isFabExpanded,
      medications: medications ?? this.medications,
    );
  }

  @override
  List<Object?> get props => [selectedTab, isFabExpanded, medications];
}
