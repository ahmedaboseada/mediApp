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
      (failure) => emit(MyBookingsFailure(failure.message)),
      (bookings) => emit(MyBookingsSuccess(bookings)),
    );
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    final result = await doctorsRepository.cancelBooking(bookingId, reason);

    result.fold(
      (failure) => emit(MyBookingsFailure(failure.message)),
      (_) async {
        // Cancel the reminder if it exists
        await LocalNotificationService.cancelAppointmentReminder(bookingId);
        LocalNotificationService.saveAppointmentRemindMe(bookingId, false);
        
        // Refresh bookings
        await fetchBookings();
      },
    );
  }
}
