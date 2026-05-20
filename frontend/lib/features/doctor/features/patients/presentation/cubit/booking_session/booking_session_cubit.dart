import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import '../../../data/models/booking_session_model.dart';
import '../../../data/repo/booking_session_repository.dart';
import 'booking_session_state.dart';

class BookingSessionCubit extends Cubit<BookingSessionState> {
  BookingSessionCubit(this._repository) : super(const BookingSessionState());

  final BookingSessionRepository _repository;

  Future<Either<ApiError, BookingSessionModel>> startSessionWithToken(
    String token,
  ) async {
    emit(state.copyWith(status: BookingSessionStatus.loading));

    final result = await _repository.startSession(token);

    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: BookingSessionStatus.failure,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(state.copyWith(status: BookingSessionStatus.started, session: r));
      },
    );

    return result;
  }

  Future<Either<ApiError, void>> endSession(String bookingId) async {
    emit(state.copyWith(status: BookingSessionStatus.ending));

    final result = await _repository.endSession(bookingId);

    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: BookingSessionStatus.failure,
            errorMessage: l.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: BookingSessionStatus.ended));
      },
    );

    return result;
  }
}
