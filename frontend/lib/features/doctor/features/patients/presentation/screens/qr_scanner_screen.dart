import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: MobileScanner(
        onDetect: (capture) {
          if (isScanned) return;

          final String? code =
              capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;

          if (code != null && code.isNotEmpty) {
            isScanned = true;

            /// 👇 رجّعي النتيجة للشاشة اللي قبله
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}