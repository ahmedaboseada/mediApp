import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openMapLocation(
  BuildContext context, {
  double? latitude,
  double? longitude,
  String? address,
}) async {
  final hasCoordinates = latitude != null && longitude != null;
  final Uri uri = hasCoordinates
      ? Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
        )
      : Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address ?? '')}',
        );

  try {
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open Google Maps on this device.'),
        ),
      );
    }

    return launched;
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open Google Maps on this device.'),
        ),
      );
    }

    return false;
  }
}