import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medi/core/widgets/custom_app_bar.dart';
import 'package:medi/core/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton exposes semantics label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PrimaryButton(text: 'Save'),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Save'), findsOneWidget);
    expect(find.byTooltip('Save'), findsOneWidget);
  });

  testWidgets('CustomAppBar exposes back semantics', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: const CustomAppBar(title: 'Details'),
          body: const SizedBox.shrink(),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Back'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
  });
}
