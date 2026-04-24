import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileQR extends StatelessWidget {
  final String qrData;

  const ProfileQR({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showQrDialog(context),
      child: QrImageView(
        data: qrData,
        size: 60, // 👈 صغير
      ),
    );
  }

  void _showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => QrDialog(qrData: qrData),
    );
  }
}

class QrDialog extends StatelessWidget {
  final String qrData;

  const QrDialog({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Scan your QR Code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QrImageView(data: qrData, size: 220),

                  /// Corners
                  Positioned(top: 0, left: 0, child: _corner()),
                  Positioned(top: 0, right: 0, child: _corner(isRight: true)),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _corner(isBottom: true),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _corner(isRight: true, isBottom: true),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _corner({bool isRight = false, bool isBottom = false}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isBottom ? BorderSide.none : BorderSide(width: 3),
          left: isRight ? BorderSide.none : BorderSide(width: 3),
          right: isRight ? BorderSide(width: 3) : BorderSide.none,
          bottom: isBottom ? BorderSide(width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}
