import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final DoctorsRepository doctorsRepository;

  BookingCubit({required this.doctorsRepository})
    : super(
        BookingState(
          appointmentReviewData: AppointmentReviewData(
            doctor: null,
            dateAndHour: '',
            packageName: 'Online',
            duration: '30 minutes',
            bookingFor: 'Self',
            amount: 60,
            unitPrice: 20,
            paymentMethod: 'card',
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
          availableSlots: [],
          isLoadingSlots: false,
        ),
      );

  Future<void> fetchAvailableSlots(String doctorId, DateTime date) async {
    emit(state.copyWith(isLoadingSlots: true));

    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final result = await doctorsRepository.getDoctorSlots(doctorId, dateStr);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingSlots: false, availableSlots: [])),
      (slots) =>
          emit(state.copyWith(isLoadingSlots: false, availableSlots: slots)),
    );
  }

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

    final doctorId = state.appointmentReviewData.doctor?.id;
    if (doctorId != null) {
      fetchAvailableSlots(doctorId, selectedDate);
    }
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

  void setDoctor(Doctordata doctor) {
    final updatedData = state.appointmentReviewData.copyWith(doctor: doctor);
    emit(state.copyWith(appointmentReviewData: updatedData));
    fetchAvailableSlots(doctor.id, state.selectedDate);
  }

  void updatePatientDetails({int? age, String? gender, String? problem, String? patientName}) {
    final updatedData = state.appointmentReviewData.copyWith(
      patientAge: age,
      patientGender: gender,
      problem: problem,
      patientName: patientName,
    );
    emit(state.copyWith(appointmentReviewData: updatedData));
  }

  String _mapPaymentMethodForApi(String paymentMethod) {
    final normalized = paymentMethod.trim().toLowerCase();
    return normalized == 'cash' ? 'cash' : 'card';
  }

  Future<void> createBooking() async {
    if (state.appointmentReviewData.doctor == null ||
        state.selectedTimeSlot == null) {
      return;
    }

    emit(
      state.copyWith(
        isBooking: true,
        bookingSuccess: false,
        bookingErrorMessage: null,
      ),
    );

    final data = state.appointmentReviewData;
    final body = {
      "doctorId": data.doctor!.id,
      "date": state.selectedDate.toIso8601String(),
      "time": state.selectedTimeSlot,
      "packageType": data.packageName.toLowerCase() == 'online'
          ? 'online'
          : 'in-person',
      "bookingFor": data.bookingFor,
      "patientAge": data.patientAge,
      "patientGender": data.patientGender.toLowerCase(),
      "problem": data.problem,
      "paymentMethod": _mapPaymentMethodForApi(data.paymentMethod),
    };

    final result = await doctorsRepository.createBooking(body);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isBooking: false,
          bookingSuccess: false,
          bookingErrorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          isBooking: false,
          bookingSuccess: true,
          bookingErrorMessage: null,
        ),
      ),
    );
  }

  Future<void> initiatePayment() async {
    if (state.appointmentReviewData.doctor == null ||
        state.selectedTimeSlot == null) {
      return;
    }

    emit(
      state.copyWith(
        isBooking: true,
        bookingSuccess: false,
        bookingErrorMessage: null,
      ),
    );

    final data = state.appointmentReviewData;
    final body = {
      "doctorId": data.doctor!.id,
      "date": state.selectedDate.toIso8601String(),
      "time": state.selectedTimeSlot,
      "packageType": data.packageName.toLowerCase() == 'online'
          ? 'online'
          : 'in-person',
      "bookingFor": data.bookingFor,
      "patientAge": data.patientAge,
      "patientGender": data.patientGender.toLowerCase(),
      "problem": data.problem,
      "paymentMethod": _mapPaymentMethodForApi(data.paymentMethod),
    };

    final result = await doctorsRepository.createBooking(body);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isBooking: false,
            paymentUrl: null,
            bookingErrorMessage: failure.message,
          ),
        );
      },
      (successResponse) {
        // Extract paymentUrl from response
        String? paymentUrl;
        try {
          if (successResponse is Map<String, dynamic>) {
            paymentUrl = successResponse['paymentUrl'] as String?;
          }
        } catch (e) {
          // Handle parsing error silently
        }

        emit(
          state.copyWith(
            isBooking: false,
            paymentUrl: paymentUrl,
            bookingErrorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> confirmPaymentSuccess() async {
    emit(state.copyWith(isProcessingPayment: true));
    // Booking was already created in initiatePayment
    // Just emit success to navigate to success screen
    emit(
      state.copyWith(
        isProcessingPayment: false,
        bookingSuccess: true,
        paymentUrl: null,
      ),
    );
  }

  void clearPaymentUrl() {
    emit(state.copyWith(paymentUrl: null));
  }
}
