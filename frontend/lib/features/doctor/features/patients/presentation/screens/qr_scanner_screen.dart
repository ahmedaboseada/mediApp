import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key, this.mockToken});

  final String? mockToken;

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: Text('Scan QR Code')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (isScanned) return;

              final String? code = capture.barcodes.isNotEmpty
                  ? capture.barcodes.first.rawValue
                  : null;

              if (code != null && code.isNotEmpty) {
                isScanned = true;
                Navigator.pop(context, code);
              }
            },
          ),
          if (widget.mockToken != null && widget.mockToken!.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, widget.mockToken),
                icon: const Icon(Icons.science_outlined),
                label: const Text('Use mock patient token'),
              ),
            ),
        ],
      ),
    );
  }
}
