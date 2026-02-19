import 'package:equatable/equatable.dart';



sealed class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

final class LocationInitial extends LocationState {}
final class LocationLoading extends LocationState {}
final class LocationSuccess extends LocationState {
  final double latitude;
  final double longitude;
  final String address;
  
  const LocationSuccess({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}
final class LocationFailure extends LocationState {
  final String error;

  const LocationFailure(this.error);

  @override
  List<Object?> get props => [error];
}