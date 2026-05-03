import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/data/repo/booking_qr_repository.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_qr_state.dart';

class BookingQrCubit extends Cubit<BookingQrState> {
  BookingQrCubit(this._repository) : super(BookingQrInitial());

  final BookingQrRepository _repository;

  Future<void> generateSessionToken(String appointmentId) async {
    emit(BookingQrLoading());

    final result = await _repository.generateSessionToken(appointmentId);

    result.fold(
      (failure) => emit(BookingQrFailure(failure.message)),
      (sessionToken) => emit(BookingQrSuccess(sessionToken)),
    );
  }
}
