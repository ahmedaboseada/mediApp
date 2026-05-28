import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:medi/core/data/sync/sync_service.dart';
import 'package:medi/core/services/pending_patient_requests_sync_service.dart';
import 'package:medi/core/services/app_logger.dart';

class ConnectivityService {
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  static void init() {
    _subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Check if any of the connections are not 'none'
      final isConnected = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (isConnected) {
        AppLogger.instance.i('Internet connected, triggering sync...');
        SyncService.processQueue();
        PendingPatientRequestsSyncService.processPendingRequests();
      }
    });
  }

  static void dispose() {
    _subscription?.cancel();
  }
}
