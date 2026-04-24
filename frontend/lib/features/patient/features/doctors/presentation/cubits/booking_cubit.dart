import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit()
    : super(
        BookingState(
          appointmentReviewData: AppointmentReviewData(
            doctor: null,
            dateAndHour: '',
            packageName: '',
            duration: '',
            bookingFor: '',
            amount: 0,
            unitPrice: 0,
            paymentMethod: '',
            location: '',
          ),
          selectedPackageIndex: 0,
          selectedDate: DateTime.now(),
          selectedTimeSlot: null,
          selectedDuration: '30 minutes',
          bookingFor: 'Self',
          selectedPaymentMethod: 'card',
          cardHolderName: '',
          cardNumber: '',
          expiryDate: '',
          cvvCode: '',
        ),
      );

  void initializeWithData(AppointmentReviewData data) {
    emit(state.copyWith(appointmentReviewData: data));
  }

  void updatePackageSelection(int packageIndex) {
    final isOnline = packageIndex == 0;
    final amount = isOnline ? 60.0 : 100.0;

    final updatedData = state.appointmentReviewData.copyWith(
      packageName: isOnline ? 'Online' : 'Offline',
      amount: amount,
      unitPrice: amount / 3,
    );

    emit(
      state.copyWith(
        selectedPackageIndex: packageIndex,
        appointmentReviewData: updatedData,
      ),
    );
  }

  void updateDuration(String duration) {
    final updatedData = state.appointmentReviewData.copyWith(
      duration: duration,
    );
    emit(
      state.copyWith(
        selectedDuration: duration,
        appointmentReviewData: updatedData,
      ),
    );
  }

  void updateSelectedDate(DateTime selectedDate) {
    final selectedTime = state.selectedTimeSlot ?? '10:00 AM';
    final formattedDate = DateFormat('MMMM d, yyyy').format(selectedDate);
    final updatedData = state.appointmentReviewData.copyWith(
      dateAndHour: '$formattedDate | $selectedTime',
    );

    emit(
      state.copyWith(
        selectedDate: selectedDate,
        appointmentReviewData: updatedData,
      ),
    );
  }

  void updateSelectedTimeSlot(String selectedTimeSlot) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(state.selectedDate);
    final updatedData = state.appointmentReviewData.copyWith(
      dateAndHour: '$formattedDate | $selectedTimeSlot',
    );

    emit(
      state.copyWith(
        selectedTimeSlot: selectedTimeSlot,
        appointmentReviewData: updatedData,
      ),
    );
  }

  void updateBookingFor(String bookingFor) {
    final updatedData = state.appointmentReviewData.copyWith(
      bookingFor: bookingFor,
    );
    emit(
      state.copyWith(
        bookingFor: bookingFor,
        appointmentReviewData: updatedData,
      ),
    );
  }

  void updatePaymentMethod(String paymentMethod) {
    final updatedData = state.appointmentReviewData.copyWith(
      paymentMethod: paymentMethod,
    );
    emit(
      state.copyWith(
        selectedPaymentMethod: paymentMethod,
        appointmentReviewData: updatedData,
      ),
    );
  }

  void updateCardDetails({
    String? cardHolderName,
    String? cardNumber,
    String? expiryDate,
    String? cvvCode,
  }) {
    emit(
      state.copyWith(
        cardHolderName: cardHolderName ?? state.cardHolderName,
        cardNumber: cardNumber ?? state.cardNumber,
        expiryDate: expiryDate ?? state.expiryDate,
        cvvCode: cvvCode ?? state.cvvCode,
      ),
    );
  }

  void setDoctor(DoctorModel doctor) {
    final updatedData = state.appointmentReviewData.copyWith(doctor: doctor);
    emit(state.copyWith(appointmentReviewData: updatedData));
  }
}
