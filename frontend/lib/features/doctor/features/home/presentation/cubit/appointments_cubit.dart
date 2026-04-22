import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/home/data/repo/appointments_repository.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit(this._repository)
      : super(AppointmentsState(selectedDate: DateTime.now()));

  final AppointmentsRepository _repository;

  Future<void> loadAppointmentsForDate(DateTime selectedDate) async {
    final normalizedDate = DateUtils.dateOnly(selectedDate);

    if (state.status == AppointmentsStatus.loading &&
        DateUtils.isSameDay(state.selectedDate, normalizedDate)) {
      return;
    }

    emit(
      state.copyWith(
        selectedDate: normalizedDate,
        status: AppointmentsStatus.loading,
        clearError: true,
      ),
    );

    final result = await _repository.getAppointmentsForDate(normalizedDate);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AppointmentsStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (appointments) {
        emit(
          state.copyWith(
            status: appointments.isEmpty
                ? AppointmentsStatus.empty
                : AppointmentsStatus.success,
            appointments: appointments,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> retry() => loadAppointmentsForDate(state.selectedDate);
}
