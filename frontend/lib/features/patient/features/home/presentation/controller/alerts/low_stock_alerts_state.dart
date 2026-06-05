import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

abstract class LowStockAlertsState extends Equatable {
  const LowStockAlertsState();

  @override
  List<Object?> get props => [];
}

class LowStockAlertsInitial extends LowStockAlertsState {}

class LowStockAlertsLoading extends LowStockAlertsState {}

class LowStockAlertsSuccess extends LowStockAlertsState {
  const LowStockAlertsSuccess({required this.lowStockMedications});

  final List<Medication> lowStockMedications;

  @override
  List<Object?> get props => [lowStockMedications];
}

class LowStockAlertsFailure extends LowStockAlertsState {
  const LowStockAlertsFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
