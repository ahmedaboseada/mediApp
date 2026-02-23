import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/secondry_button.dart';

class InvitationSendScreen extends StatelessWidget {
  const InvitationSendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(AppAssets.completeProfile),
          Text(AppStrings.invitationSent, style: AppStyles.black24700),
          PrimaryButton(
            text: AppStrings.done,
            onPressed: () {
              
            },

          ),
          SecondryButton(
            text: 'Add another person',
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
