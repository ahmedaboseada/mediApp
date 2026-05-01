import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:medi/core/core.dart';

class PaymobCheckoutScreen extends StatefulWidget {
  final String checkoutUrl;
  const PaymobCheckoutScreen({Key? key, required this.checkoutUrl})
      : super(key: key);

  @override
  State<PaymobCheckoutScreen> createState() => _PaymobCheckoutScreenState();
}

class _PaymobCheckoutScreenState extends State<PaymobCheckoutScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  void _checkPaymentStatus(String url) {
    final normalizedUrl = url.toLowerCase();

    final isSuccess = normalizedUrl.contains('success=true') ||
        normalizedUrl.contains('status=success') ||
        normalizedUrl.contains('paid');

    final isFailure = normalizedUrl.contains('success=false') ||
        normalizedUrl.contains('status=failed') ||
        normalizedUrl.contains('failed');

    if (isSuccess) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });
    } else if (isFailure) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context, false);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _checkPaymentStatus(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            // Paymob redirects back to our Transaction Response Callback URL
            // We intercept this URL to check if the payment succeeded or failed
            _checkPaymentStatus(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Pay with Paymob'),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
