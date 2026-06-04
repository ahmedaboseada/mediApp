import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/settings/data/repo/notification_settings_repo.dart';
import 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final NotificationSettingsRepo _repo;

  NotificationSettingsCubit(this._repo) : super(const NotificationSettingsState());

  Future<void> loadSettings() async {
    final email = await _repo.getLocalToggle('email');
    final sms = await _repo.getLocalToggle('sms');
    final appointment = await _repo.getLocalToggle('appointment');
    final patient = await _repo.getLocalToggle('patient');
    final medication = await _repo.getLocalToggle('medication');
    final system = await _repo.getLocalToggle('system');

    emit(state.copyWith(
      emailNotifications: email,
      smsNotifications: sms,
      appointmentReminders: appointment,
      patientUpdates: patient,
      medicationAlerts: medication,
      systemUpdates: system,
    ));
  }

  Future<void> toggleEmail(bool value) async {
    emit(state.copyWith(emailNotifications: value));
    await _repo.saveLocalToggle('email', value);
    try {
      await _repo.updateSettings({'email': value});
    } catch (e) {
      debugPrint('Error updating email setting: $e');
      // Revert if API fails?
      // emit(state.copyWith(emailNotifications: !value));
      // await _repo.saveLocalToggle('email', !value);
    }
  }

  Future<void> toggleSms(bool value) async {
    emit(state.copyWith(smsNotifications: value));
    await _repo.saveLocalToggle('sms', value);
  }

  Future<void> toggleAppointment(bool value) async {
    emit(state.copyWith(appointmentReminders: value));
    await _repo.saveLocalToggle('appointment', value);
  }

  Future<void> togglePatient(bool value) async {
    emit(state.copyWith(patientUpdates: value));
    await _repo.saveLocalToggle('patient', value);
  }

  Future<void> toggleMedication(bool value) async {
    emit(state.copyWith(medicationAlerts: value));
    await _repo.saveLocalToggle('medication', value);
  }

  Future<void> toggleSystem(bool value) async {
    emit(state.copyWith(systemUpdates: value));
    await _repo.saveLocalToggle('system', value);
    try {
      await _repo.updateSettings({'push': value});
    } catch (e) {
      debugPrint('Error updating system push setting: $e');
    }
  }
}
