import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/doctors/data/models/booking_model.dart';

abstract class MyBookingsState extends Equatable {
  const MyBookingsState();

  @override
  List<Object?> get props => [];
}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsSuccess extends MyBookingsState {
  final List<BookingModel> bookings;

  const MyBookingsSuccess(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class MyBookingsFailure extends MyBookingsState {
  final String message;

  const MyBookingsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class MyBookingsActionSuccess extends MyBookingsState {
  final String message;

  const MyBookingsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
