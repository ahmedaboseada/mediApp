import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:medi/core/data/sync/sync_service.dart';

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
        print('Internet connected, triggering sync...');
        SyncService.processQueue();
      }
    });
  }

  static void dispose() {
    _subscription?.cancel();
  }
}
