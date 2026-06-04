
abstract class NotificationSettingsRepo {
  Future<void> updateSettings(Map<String, dynamic> notifications);
  Future<void> saveLocalToggle(String key, bool value);
  Future<bool> getLocalToggle(String key);
}
