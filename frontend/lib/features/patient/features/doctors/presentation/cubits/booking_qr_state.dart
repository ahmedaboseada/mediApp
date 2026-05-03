import 'package:equatable/equatable.dart';

abstract class BookingQrState extends Equatable {
  const BookingQrState();

  @override
  List<Object?> get props => [];
}

class BookingQrInitial extends BookingQrState {}

class BookingQrLoading extends BookingQrState {}

class BookingQrSuccess extends BookingQrState {
  const BookingQrSuccess(this.sessionToken);

  final String sessionToken;

  @override
  List<Object?> get props => [sessionToken];
}

class BookingQrFailure extends BookingQrState {
  const BookingQrFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
