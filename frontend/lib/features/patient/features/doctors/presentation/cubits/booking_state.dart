part of 'booking_cubit.dart';

class BookingState {
  final AppointmentReviewData appointmentReviewData;
  final int selectedPackageIndex;
  final DateTime selectedDate;
  final String? selectedTimeSlot;
  final String selectedDuration;
  final String bookingFor;
  final String selectedPaymentMethod;
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String cvvCode;

  const BookingState({
    required this.appointmentReviewData,
    required this.selectedPackageIndex,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.selectedDuration,
    required this.bookingFor,
    required this.selectedPaymentMethod,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvvCode,
  });

  BookingState copyWith({
    AppointmentReviewData? appointmentReviewData,
    int? selectedPackageIndex,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    String? selectedDuration,
    String? bookingFor,
    String? selectedPaymentMethod,
    String? cardHolderName,
    String? cardNumber,
    String? expiryDate,
    String? cvvCode,
  }) {
    return BookingState(
      appointmentReviewData:
          appointmentReviewData ?? this.appointmentReviewData,
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      bookingFor: bookingFor ?? this.bookingFor,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvvCode: cvvCode ?? this.cvvCode,
    );
  }
}
