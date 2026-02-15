import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class InvitationSentScreen extends StatelessWidget {
  const InvitationSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(AppAssets.completeProfile),
          Text(AppStrings.invitationSent, style: AppStyles.screenTitle),
        ],
      ),
    );
  }
}
