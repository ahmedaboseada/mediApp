import 'package:flutter/semantics.dart';
import 'dart:developer' as developer;

/// Lightweight accessibility service for screen reader announcements.
/// 
/// This service uses SemanticsService.announce() to announce important
/// events to screen readers like TalkBack (Android) and VoiceOver (iOS).
/// 
/// Usage:
///   AccessibilityService.announce('Payment successful');
///   AccessibilityService.announceWithAssistant('Login failed: ${error.message}');
class AccessibilityService {
  static const String _tag = '[Accessibility]';

  /// Announce a message to screen readers.
  /// 
  /// This is the primary method for announcing events. The message will be
  /// read by active screen readers (TalkBack/VoiceOver).
  /// 
  /// Example:
  ///   AccessibilityService.announce('Appointment booked successfully');
  static Future<void> announce(String message, {TextDirection? textDirection}) async {
    try {
      developer.log('$_tag Announcing: $message', name: 'a11y');
      await SemanticsService.announce(message, textDirection ?? TextDirection.ltr);
    } catch (e) {
      developer.log('$_tag Error announcing message: $e', name: 'a11y');
    }
  }

  /// Announce a message with automatic RTL detection for Arabic text.
  /// 
  /// Detects if the message contains Arabic characters and automatically
  /// sets the text direction to RTL if needed.
  /// 
  /// Example:
  ///   AccessibilityService.announceWithRTL('تم حجز الموعد بنجاح');
  static Future<void> announceWithRTL(String message) async {
    try {
      final textDirection = _detectTextDirection(message);
      await announce(message, textDirection: textDirection);
    } catch (e) {
      developer.log('$_tag Error in announceWithRTL: $e', name: 'a11y');
    }
  }

  /// Announce a success message.
  /// 
  /// Example:
  ///   AccessibilityService.announceSuccess('Login successful');
  static Future<void> announceSuccess(String message) async {
    await announce('Success: $message');
  }

  /// Announce an error message.
  /// 
  /// Example:
  ///   AccessibilityService.announceError('Invalid email address');
  static Future<void> announceError(String message) async {
    await announce('Error: $message');
  }

  /// Announce a loading state.
  /// 
  /// Example:
  ///   AccessibilityService.announceLoading('Booking appointment');
  static Future<void> announceLoading(String message) async {
    await announce('$message, loading');
  }

  /// Announce a loading completion.
  /// 
  /// Example:
  ///   AccessibilityService.announceLoadingComplete('Booking appointment completed');
  static Future<void> announceLoadingComplete(String message) async {
    await announce('$message, completed');
  }

  /// Announce navigation to a new screen.
  /// 
  /// Example:
  ///   AccessibilityService.announceNavigation('Navigated to home screen');
  static Future<void> announceNavigation(String screenName) async {
    await announce('Navigated to $screenName');
  }

  /// Announce a dialog opened.
  /// 
  /// Example:
  ///   AccessibilityService.announceDialog('Confirm logout', 'Confirm action');
  static Future<void> announceDialog(String title, String description) async {
    await announce('Dialog: $title, $description');
  }

  /// Announce a bottom sheet opened.
  /// 
  /// Example:
  ///   AccessibilityService.announceBottomSheet('Select medication');
  static Future<void> announceBottomSheet(String title) async {
    await announce('Bottom sheet opened: $title');
  }

  /// Detect text direction for a message.
  /// Returns RTL for Arabic text, LTR otherwise.
  static TextDirection _detectTextDirection(String text) {
    // Arabic Unicode range: 0x0600 to 0x06FF
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

}
