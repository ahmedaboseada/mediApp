class NotificationSettingsState {
  final bool emailNotifications;
  final bool smsNotifications;
  final bool appointmentReminders;
  final bool patientUpdates;
  final bool medicationAlerts;
  final bool systemUpdates;

  const NotificationSettingsState({
    this.emailNotifications = false,
    this.smsNotifications = false,
    this.appointmentReminders = false,
    this.patientUpdates = false,
    this.medicationAlerts = false,
    this.systemUpdates = false,
  });

  NotificationSettingsState copyWith({
    bool? emailNotifications,
    bool? smsNotifications,
    bool? appointmentReminders,
    bool? patientUpdates,
    bool? medicationAlerts,
    bool? systemUpdates,
  }) {
    return NotificationSettingsState(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      patientUpdates: patientUpdates ?? this.patientUpdates,
      medicationAlerts: medicationAlerts ?? this.medicationAlerts,
      systemUpdates: systemUpdates ?? this.systemUpdates,
    );
  }
}
