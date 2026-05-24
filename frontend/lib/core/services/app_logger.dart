import 'package:logger/logger.dart';

/// Wrapper around `package:logger` to provide a single logger instance.
class AppLogger {
  AppLogger._();

  static final Logger instance = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
}
