import '../../../data/models/booking_session_model.dart';

enum BookingSessionStatus { initial, loading, started, ending, ended, failure }

class BookingSessionState {
  const BookingSessionState({
    this.status = BookingSessionStatus.initial,
    this.session,
    this.errorMessage,
  });

  final BookingSessionStatus status;
  final BookingSessionModel? session;
  final String? errorMessage;

  BookingSessionState copyWith({
    BookingSessionStatus? status,
    BookingSessionModel? session,
    String? errorMessage,
  }) {
    return BookingSessionState(
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
