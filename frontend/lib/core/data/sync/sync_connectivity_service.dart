import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:medi/core/services/app_logger.dart';

class SyncConnectivityService {
  final Connectivity connectivity;

  SyncConnectivityService({Connectivity? connectivity})
      : connectivity = connectivity ?? Connectivity();

  Future<bool> hasRealInternet() async {
    try {
      final results = await connectivity.checkConnectivity();
      if (results.any((result) => result == ConnectivityResult.none)) {
        return false;
      }

      final lookup = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 5),
      );
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (e, st) {
      AppLogger.instance.w('Connectivity check failed', e, st);
      return false;
    }
  }
}
