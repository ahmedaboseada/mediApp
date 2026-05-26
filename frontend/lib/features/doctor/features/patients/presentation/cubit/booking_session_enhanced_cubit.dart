// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:medi/core/core.dart';
// import '../../data/models/booking_session_model.dart';
// import '../../data/repo/booking_session_repository.dart';
// import 'booking_session_state_enhanced.dart';

// /// Enhanced Cubit for managing booking sessions with timer support.
// /// Handles:
// /// - Starting and ending sessions via repository calls
// /// - Session countdown timer (manages internally, emits state changes)
// /// - Session expiration detection
// /// - All time formatting and calculations
// /// This keeps the UI layer pure and reactive.
// class BookingSessionEnhancedCubit extends Cubit<BookingSessionState> {
//   BookingSessionEnhancedCubit(this._repository)
//     : super(const BookingSessionState());

//   final BookingSessionRepository _repository;
//   Timer? _sessionTimer;

//   /// Starts a booking session with the provided token.
//   /// On success, initializes the countdown timer.
//   Future<Either<ApiError, BookingSessionModel>> startSessionWithToken(
//     String token,
//   ) async {
//     emit(state.copyWith(status: BookingSessionStatus.loading));

//     final result = await _repository.startSession(token);

//     result.fold(
//       (error) {
//         emit(
//           state.copyWith(
//             status: BookingSessionStatus.failure,
//             errorMessage: error.message,
//           ),
//         );
//       },
//       (session) {
//         emit(
//           state.copyWith(
//             status: BookingSessionStatus.started,
//             session: session,
//           ),
//         );
//         _startSessionTimer(session.expiresAt);
//       },
//     );

//     return result;
//   }

//   /// Ends the current booking session.
//   /// Calls repository to notify backend, then updates state.
//   Future<Either<ApiError, void>> endCurrentSession() async {
//     final session = state.session;
//     if (session == null) {
//       return const Right(null);
//     }

//     emit(state.copyWith(status: BookingSessionStatus.ending));
//     _sessionTimer?.cancel();

//     final result = await _repository.endSession(session.bookingId);

//     result.fold(
//       (error) {
//         emit(
//           state.copyWith(
//             status: BookingSessionStatus.failure,
//             errorMessage: error.message,
//           ),
//         );
//       },
//       (_) {
//         emit(
//           state.copyWith(
//             status: BookingSessionStatus.ended,
//             shouldNavigateBack: true,
//           ),
//         );
//       },
//     );

//     return result;
//   }

//   /// Initializes and manages the countdown timer.
//   /// Updates state every second with remaining time.
//   void _startSessionTimer(String expiresAtString) {
//     _sessionTimer?.cancel();

//     final expiresAt = DateTime.tryParse(expiresAtString);
//     if (expiresAt == null) {
//       emit(
//         state.copyWith(
//           status: BookingSessionStatus.failure,
//           errorMessage: 'Invalid expiration time format',
//         ),
//       );
//       return;
//     }

//     void updateRemainingTime() {
//       final remaining = expiresAt.difference(DateTime.now());

//       if (remaining.isNegative || remaining.inSeconds <= 0) {
//         _sessionTimer?.cancel();
//         emit(
//           state.copyWith(
//             status: BookingSessionStatus.expired,
//             remainingTime: Duration.zero,
//           ),
//         );
//         return;
//       }

//       emit(
//         state.copyWith(
//           status: BookingSessionStatus.timerRunning,
//           remainingTime: remaining,
//         ),
//       );
//     }

//     updateRemainingTime();
//     _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       updateRemainingTime();
//     });
//   }

//   /// Formats duration to HH:MM:SS format.
//   static String formatDuration(Duration duration) {
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes.remainder(60);
//     final seconds = duration.inSeconds.remainder(60);
//     final parts = <String>[];

//     if (hours > 0) {
//       parts.add(hours.toString().padLeft(2, '0'));
//     }
//     parts.add(minutes.toString().padLeft(2, '0'));
//     parts.add(seconds.toString().padLeft(2, '0'));

//     return parts.join(':');
//   }

//   @override
//   Future<void> close() {
//     _sessionTimer?.cancel();
//     return super.close();
//   }
// }
