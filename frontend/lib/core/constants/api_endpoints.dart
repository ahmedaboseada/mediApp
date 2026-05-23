/// API Endpoints for MediApp
class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();

  // Base URL - Update this for production
  static const String baseUrl = 'https://api.mediapp.com/v1';

  // FCM v1 dispatch endpoint
  static const String fcmBaseUrl = 'https://fcm.googleapis.com/v1/projects/medi-31350';
  static const String fcmSendMessagePath = '/messages:send';
}
