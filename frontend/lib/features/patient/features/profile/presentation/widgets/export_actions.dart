import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class ExportActions extends StatelessWidget {
  const ExportActions({super.key, required this.onExport, required this.onShowQR});
 final VoidCallback onExport;
 final VoidCallback onShowQR;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: PrimaryButton(
            onPressed: onExport,
           text: 'Export',
          ),
        ),
        SizedBox(width: AppSizes.w16),
        Expanded(
          child: PrimaryButton(
            onPressed: onShowQR,
            text: 'Show QR',
          ),
        ),
      ],
    );
  }
}