import 'package:flutter/material.dart';
import 'package:medi/core/services/local_notification_service.dart';

/// Development-only helper for debugging scheduled reminders.
/// Usage:
///   1. Add [DebugScheduleHelper()] to your screen's Stack
///   2. Tap the debug button in bottom-right corner to print all scheduled reminders
///   3. Check console output for reminder IDs and fire times
///   4. Wrap in kDebugMode or dev-flag check for production builds
class DebugScheduleHelper extends StatefulWidget {
  const DebugScheduleHelper({super.key, this.position = DebugPosition.bottomRight});

  final DebugPosition position;

  @override
  State<DebugScheduleHelper> createState() => _DebugScheduleHelperState();
}

enum DebugPosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

class _DebugScheduleHelperState extends State<DebugScheduleHelper> {
  bool _showDebug = false;

  @override
  Widget build(BuildContext context) {
    if (!_showDebug) {
      return Positioned(
        right: widget.position == DebugPosition.bottomRight ||
                widget.position == DebugPosition.topRight
            ? 16
            : null,
        left: widget.position == DebugPosition.bottomLeft ||
                widget.position == DebugPosition.topLeft
            ? 16
            : null,
        bottom: widget.position == DebugPosition.bottomRight ||
                widget.position == DebugPosition.bottomLeft
            ? 16
            : null,
        top: widget.position == DebugPosition.topRight ||
                widget.position == DebugPosition.topLeft
            ? 16
            : null,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.deepPurple.withOpacity(0.7),
          onPressed: () {
            setState(() => _showDebug = true);
            LocalNotificationService.printScheduledRemindersDebug();
          },
          tooltip: 'Print scheduled reminders (DEBUG)',
          child: const Icon(Icons.bug_report, size: 20),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

/// Quick helper to print scheduled reminders to console.
/// Call this from any BuildContext:
///   LocalNotificationService.printScheduledRemindersDebug();
/// Check console for output.
class DebugRemindersButton extends StatelessWidget {
  const DebugRemindersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: LocalNotificationService.printScheduledRemindersDebug,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Debug Reminders',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
