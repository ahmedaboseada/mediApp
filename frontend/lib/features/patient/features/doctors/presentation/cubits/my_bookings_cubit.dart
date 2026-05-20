import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final DoctorsRepository doctorsRepository;

  MyBookingsCubit({required this.doctorsRepository})
    : super(MyBookingsInitial());

  Future<void> fetchBookings() async {
    emit(MyBookingsLoading());

    final result = await doctorsRepository.getPatientBookings();

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(MyBookingsFailure(failure.message));
      },
      (bookings) {
        if (isClosed) return;
        emit(MyBookingsSuccess(bookings));
      },
    );
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    final result = await doctorsRepository.cancelBooking(bookingId, reason);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(MyBookingsFailure(failure.message));
      },
      (_) async {
        // Cancel the reminder if it exists
        await LocalNotificationService.cancelAppointmentReminder(bookingId);
        LocalNotificationService.saveAppointmentRemindMe(bookingId, false);

        emit(const MyBookingsActionSuccess('Appointment cancelled'));

        // Refresh bookings
        await fetchBookings();
      },
    );
  }

  Future<void> rescheduleBooking({
    required String bookingId,
    required String date,
    required String time,
    required String doctorName,
  }) async {
    final result = await doctorsRepository.rescheduleBooking(
      bookingId,
      date,
      time,
    );

    result.fold((failure) => emit(MyBookingsFailure(failure.message)), (
      _,
    ) async {
      // If reminder was ON, reschedule it
      final isRemindMeOn = LocalNotificationService.getAppointmentRemindMe(
        bookingId,
      );
      if (isRemindMeOn) {
        await LocalNotificationService.scheduleAppointmentReminder(
          bookingId,
          doctorName,
          DateTime.parse(date),
          time,
        );
      }

      emit(const MyBookingsActionSuccess('Appointment rescheduled'));

      // Refresh bookings
      await fetchBookings();
    });
  }
}
