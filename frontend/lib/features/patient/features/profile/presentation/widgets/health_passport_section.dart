import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class HealthPassportSection extends StatelessWidget {
  const HealthPassportSection({
    super.key,
    required this.title,
    required this.children,
    this.controller,
    this.onAddPressed,
  });

  final String title;
  final List<Widget> children;
  final TextEditingController? controller;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyles.black18500),
            SizedBox(height: AppSizes.h16),
            Wrap(
              spacing: AppSizes.w8,
              runSpacing: AppSizes.h8,
              children: children,
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: '',
              hintText: 'Add new $title',
              controller: controller,
              maxLines: 1,
              suffixIcon: onAddPressed != null
                  ? IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.primary),
                      onPressed: onAddPressed,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
