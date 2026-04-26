import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

abstract class ConnectedDoctorsState extends Equatable {
  const ConnectedDoctorsState();

  @override
  List<Object?> get props => [];
}

class ConnectedDoctorsInitial extends ConnectedDoctorsState {}

class ConnectedDoctorsLoading extends ConnectedDoctorsState {}

class ConnectedDoctorsLoaded extends ConnectedDoctorsState {
  final List<Doctordata> doctors;

  const ConnectedDoctorsLoaded(this.doctors);

  @override
  List<Object?> get props => [doctors];
}

class ConnectedDoctorsError extends ConnectedDoctorsState {
  final String message;

  const ConnectedDoctorsError(this.message);

  @override
  List<Object?> get props => [message];
}
