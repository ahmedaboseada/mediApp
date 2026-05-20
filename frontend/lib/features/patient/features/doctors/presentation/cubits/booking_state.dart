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
  final List<String> availableSlots;
  final bool isLoadingSlots;
  final bool isBooking;
  final bool bookingSuccess;
  final String? paymentUrl;
  final bool isProcessingPayment;

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
    this.availableSlots = const [],
    this.isLoadingSlots = false,
    this.isBooking = false,
    this.bookingSuccess = false,
    this.paymentUrl,
    this.isProcessingPayment = false,
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
    List<String>? availableSlots,
    bool? isLoadingSlots,
    bool? isBooking,
    bool? bookingSuccess,
    String? paymentUrl,
    bool? isProcessingPayment,
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
      availableSlots: availableSlots ?? this.availableSlots,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      isBooking: isBooking ?? this.isBooking,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
    );
  }
}
