import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DeleteButton extends StatefulWidget {
  const DeleteButton({super.key, required this.onConfirmedDelete});

  final VoidCallback onConfirmedDelete;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  bool _pressed = false;

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScaleTransition(
        scale: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeOutBack,
        ),
        child: AlertDialog(
          backgroundColor: AppColors.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Medication',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Are you sure you want to delete this medication? This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF3B30),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      widget.onConfirmedDelete();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 950),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          _showDeleteConfirmation();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _pressed ? 0.97 : 1,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: AppSizes.h16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(AppSizes.r80),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF3B30).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: AppSizes.sp16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
