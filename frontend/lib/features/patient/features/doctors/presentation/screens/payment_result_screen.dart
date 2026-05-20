import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class PaymentResultScreen extends StatefulWidget {
  const PaymentResultScreen({super.key, required this.status});

  final String status;

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  bool _handled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_handled) {
      return;
    }

    _handled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final normalizedStatus = widget.status.toLowerCase();
      final isSuccess =
          normalizedStatus == 'success' ||
          normalizedStatus == 'paid' ||
          normalizedStatus == 'true';
      final reviewData = getIt<PaymentFlowCache>().consumePendingReviewData();

      if (isSuccess) {
        if (reviewData == null) {
          context.go(AppRouter.patientPaymentFailureScreen);
          return;
        }

        context.go(AppRouter.patientPaymentSuccessScreen, extra: reviewData);
      } else {
        getIt<PaymentFlowCache>().clear();
        context.go(AppRouter.patientPaymentFailureScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Semantics(
        liveRegion: true,
        label: 'Processing payment result',
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
    );
  }
}
