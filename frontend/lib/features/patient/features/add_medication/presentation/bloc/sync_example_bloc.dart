// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:medi/core/services/hive_service.dart';
// import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

// // --- Events ---
// abstract class MedicationEvent {}

// class LoadMedications extends MedicationEvent {}

// class AddMedication extends MedicationEvent {
//   final Medication medication;
//   AddMedication(this.medication);
// }

// class UpdateMedication extends MedicationEvent {
//   final Medication original;
//   final Medication updated;
//   UpdateMedication({required this.original, required this.updated});
// }

// class DeleteMedication extends MedicationEvent {
//   final Medication medication;
//   DeleteMedication(this.medication);
// }

// // --- State ---
// class MedicationState {
//   final List<Medication> medications;
//   final bool isLoading;
//   final String? error;

//   MedicationState({
//     this.medications = const [],
//     this.isLoading = false,
//     this.error,
//   });

//   MedicationState copyWith({
//     List<Medication>? medications,
//     bool? isLoading,
//     String? error,
//   }) {
//     return MedicationState(
//       medications: medications ?? this.medications,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }
// }

// // --- Bloc ---
// class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
//   MedicationBloc() : super(MedicationState()) {
//     on<LoadMedications>(_onLoadMedications);
//     on<AddMedication>(_onAddMedication);
//     on<UpdateMedication>(_onUpdateMedication);
//     on<DeleteMedication>(_onDeleteMedication);
//   }

//   Future<void> _onLoadMedications(LoadMedications event, Emitter<MedicationState> emit) async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       final medications = HiveService.getMedications();
//       emit(state.copyWith(medications: medications, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(error: e.toString(), isLoading: false));
//     }
//   }

//   Future<void> _onAddMedication(AddMedication event, Emitter<MedicationState> emit) async {
//     // Optimistic Update
//     final optimisticList = List<Medication>.from(state.medications)..add(event.medication);
//     emit(state.copyWith(medications: optimisticList));

//     try {
//       await HiveService.addMedication(event.medication);
//       // Reload to ensure we have the generated UUID and correct state
//       add(LoadMedications());
//     } catch (e) {
//       emit(state.copyWith(error: e.toString()));
//       // Revert on error
//       add(LoadMedications());
//     }
//   }

//   Future<void> _onUpdateMedication(UpdateMedication event, Emitter<MedicationState> emit) async {
//     // Optimistic Update
//     final index = state.medications.indexOf(event.original);
//     if (index != -1) {
//       final optimisticList = List<Medication>.from(state.medications);
//       optimisticList[index] = event.updated;
//       emit(state.copyWith(medications: optimisticList));
//     }

//     try {
//       await HiveService.updateMedication(original: event.original, updated: event.updated);
//       add(LoadMedications());
//     } catch (e) {
//       emit(state.copyWith(error: e.toString()));
//       add(LoadMedications());
//     }
//   }

//   Future<void> _onDeleteMedication(DeleteMedication event, Emitter<MedicationState> emit) async {
//     // Optimistic Update
//     final optimisticList = List<Medication>.from(state.medications)..remove(event.medication);
//     emit(state.copyWith(medications: optimisticList));

//     try {
//       await HiveService.deleteMedication(event.medication);
//       add(LoadMedications());
//     } catch (e) {
//       emit(state.copyWith(error: e.toString()));
//       add(LoadMedications());
//     }
//   }
// }
