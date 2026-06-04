import 'dart:developer';

import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/local/pending_patient_requests_local_data_source.dart';

class PendingPatientRequestsSyncService {
  static final _local = getIt<PendingPatientRequestsLocalDataSource>();
  static final _api = getIt<ApiService>();

  /// Attempts to send all pending add-patient requests and removes them on success.
  static Future<void> processPendingRequests() async {
    try {
      final pending = await _local.getPendingRequests();
      if (pending.isEmpty) return;

      for (final req in pending) {
        final patientId = (req['patientId'] ?? req['id'])?.toString();
        if (patientId == null) continue;

        try {
          final response = await _api.post('/doctors/patients/connect-patient', {'patientId': patientId});
          if (response is! ServerFailure) {
            await _local.removePendingRequestByPatientId(patientId);
            log('PendingPatientRequestsSync: synced request for $patientId');
          } else {
            log('PendingPatientRequestsSync: server failed for $patientId: ${response.message}');
          }
        } catch (e) {
          log('PendingPatientRequestsSync: error sending $patientId: $e');
        }
      }
    } catch (e) {
      log('PendingPatientRequestsSync: failed processing pending requests: $e');
    }
  }
}
