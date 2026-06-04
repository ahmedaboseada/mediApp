import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/core.dart';
import 'notification_settings_repo.dart';

class NotificationSettingsRepoImpl implements NotificationSettingsRepo {
  final ApiService apiService;

  NotificationSettingsRepoImpl(this.apiService);

  @override
  Future<void> updateSettings(Map<String, dynamic> notifications) async {
    final dynamic response = await apiService.patch(
      '/users/settings',
      {
        'settings': {
          'notifications': notifications,
        }
      },
    );
    log('Updated notification settings: $response');
  }

  @override
  Future<void> saveLocalToggle(String key, bool value) async {
    if (Hive.isBoxOpen('settingsBox')) {
      final box = Hive.box('settingsBox');
      await box.put('notification_toggle_$key', value);
    }
  }

  @override
  Future<bool> getLocalToggle(String key) async {
    if (Hive.isBoxOpen('settingsBox')) {
      final box = Hive.box('settingsBox');
      return box.get('notification_toggle_$key', defaultValue: false) as bool;
    }
    return false;
  }
}
