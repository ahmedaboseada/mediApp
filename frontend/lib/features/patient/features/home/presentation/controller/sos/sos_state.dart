part of 'sos_cubit.dart';

abstract class SosState extends Equatable {
  const SosState();

  @override
  List<Object?> get props => [];
}

class SosInitial extends SosState {
  const SosInitial();
}

class SosLoading extends SosState {
  const SosLoading();
}

class EmergencyContactSetSuccess extends SosState {
  final String message;
  final String contactName;
  final String contactMethod;

  const EmergencyContactSetSuccess({
    required this.message,
    required this.contactName,
    required this.contactMethod,
  });

  @override
  List<Object?> get props => [message, contactName, contactMethod];
}

class SosTriggeredSuccess extends SosState {
  final String message;

  const SosTriggeredSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class SosFailure extends SosState {
  final String message;

  const SosFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
