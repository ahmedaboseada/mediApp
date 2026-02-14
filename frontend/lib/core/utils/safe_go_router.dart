import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension SafeGoRouter on BuildContext {
  void runAfterFrame(VoidCallback action) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      action();
    });
  }

  void showSafeSnackBar(String message) {
    runAfterFrame(() {
      ScaffoldMessenger.of(this)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  }

  void safeGo(String location, {Object? extra}) {
    runAfterFrame(() {
      FocusScope.of(this).unfocus();
      go(location, extra: extra);
    });
  }

  void safePush(String location, {Object? extra}) {
    runAfterFrame(() {
      FocusScope.of(this).unfocus();
      push(location, extra: extra);
    });
  }

  void safePop([Object? result]) {
    runAfterFrame(() {
      if (canPop()) {
        pop(result);
      }
    });
  }
}
