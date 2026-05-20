import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';

class PaymentFlowCache {
  AppointmentReviewData? _pendingReviewData;

  void setPendingReviewData(AppointmentReviewData reviewData) {
    _pendingReviewData = reviewData;
  }

  AppointmentReviewData? consumePendingReviewData() {
    final reviewData = _pendingReviewData;
    _pendingReviewData = null;
    return reviewData;
  }

  void clear() {
    _pendingReviewData = null;
  }
}
