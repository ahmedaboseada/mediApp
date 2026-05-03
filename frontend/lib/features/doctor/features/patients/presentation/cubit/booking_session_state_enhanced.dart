// import '../../data/models/booking_session_model.dart';

// enum BookingSessionStatus {
//   initial,
//   loading,
//   started,
//   timerRunning,
//   expired,
//   ending,
//   ended,
//   failure,
// }

// /// Enhanced state model for booking session with timer support.
// /// Contains all information needed to display session status and countdown timer.
// class BookingSessionState {
//   const BookingSessionState({
//     this.status = BookingSessionStatus.initial,
//     this.session,
//     this.remainingTime = Duration.zero,
//     this.errorMessage,
//     this.shouldNavigateBack = false,
//   });

//   final BookingSessionStatus status;
//   final BookingSessionModel? session;

//   /// Remaining time until session expires.
//   final Duration remainingTime;

//   final String? errorMessage;

//   /// Flag to trigger navigation back when session ends.
//   final bool shouldNavigateBack;

//   bool get isSessionActive => status == BookingSessionStatus.timerRunning;
//   bool get isSessionExpired => status == BookingSessionStatus.expired;
//   bool get isEndingSession => status == BookingSessionStatus.ending;

//   BookingSessionState copyWith({
//     BookingSessionStatus? status,
//     BookingSessionModel? session,
//     Duration? remainingTime,
//     String? errorMessage,
//     bool? shouldNavigateBack,
//   }) {
//     return BookingSessionState(
//       status: status ?? this.status,
//       session: session ?? this.session,
//       remainingTime: remainingTime ?? this.remainingTime,
//       errorMessage: errorMessage ?? this.errorMessage,
//       shouldNavigateBack: shouldNavigateBack ?? this.shouldNavigateBack,
//     );
//   }
// }
