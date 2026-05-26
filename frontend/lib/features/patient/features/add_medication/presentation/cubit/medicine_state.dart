import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

enum MedicineTab { all, active, chronic }

class MedicineState extends Equatable {
  const MedicineState({
    required this.selectedTab,
    required this.isFabExpanded,
    required this.medications,
    this.isLoading = false,
    this.error,
  });

  factory MedicineState.initial(List<Medication> medications) {
    return MedicineState(
      selectedTab: MedicineTab.all,
      isFabExpanded: false,
      medications: medications,
      isLoading: false,
    );
  }

  final MedicineTab selectedTab;
  final bool isFabExpanded;
  final List<Medication> medications;

  // 🔥 added
  final bool isLoading;
  final String? error;

  MedicineState copyWith({
    MedicineTab? selectedTab,
    bool? isFabExpanded,
    List<Medication>? medications,
    bool? isLoading,
    String? error,
  }) {
    return MedicineState(
      selectedTab: selectedTab ?? this.selectedTab,
      isFabExpanded: isFabExpanded ?? this.isFabExpanded,
      medications: medications ?? this.medications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    isFabExpanded,
    medications,
    isLoading,
    error,
  ];
}
