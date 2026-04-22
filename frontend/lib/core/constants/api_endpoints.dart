/// API Endpoints for MediApp
class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();

  // Base URL - Update this for production
  static const String baseUrl = 'https://api.mediapp.com/v1';

  // ========== AUTH ENDPOINTS ==========
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh-token';
  static const String socialLogin = '/auth/social-login';

  // ========== USER/PROFILE ENDPOINTS ==========
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String uploadImage = '/user/upload-image';
  static const String deleteAccount = '/user/delete';

  // ========== DOCTOR ENDPOINTS ==========
  static const String doctorProfile = '/doctor/profile';
  static const String updateDoctorProfile = '/doctor/profile/update';
  static const String doctorSpecializations = '/doctor/specializations';
  static const String doctorVerification = '/doctor/verification';
  static const String doctorLicense = '/doctor/license';
  static const String doctorAppointments = '/doctor/appointments';

  // ========== PATIENT ENDPOINTS ==========
  static const String patientProfile = '/patient/profile';
  static const String updatePatientProfile = '/patient/profile/update';
  static const String patientMedications = '/patient/medications';
  static const String patientQuestionnaire = '/patient/questionnaire';

  // ========== CAREGIVER ENDPOINTS ==========
  static const String caregiverInvite = '/caregiver/invite';
  static const String caregiverAccept = '/caregiver/accept';
  static const String caregiverList = '/caregiver/list';
  static const String caregiverRemove = '/caregiver/remove';

  // ========== MEDICATION ENDPOINTS ==========
  static const String medications = '/medications';
  static const String addMedication = '/medications/add';
  static const String updateMedication = '/medications/update';
  static const String deleteMedication = '/medications/delete';
  static const String medicationReminders = '/medications/reminders';

  // ========== NOTIFICATION ENDPOINTS ==========
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/read';
  static const String notificationSettings = '/notifications/settings';
}
