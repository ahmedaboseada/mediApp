import 'package:flutter/foundation.dart';

class HomeScheduleRefreshBus {
  HomeScheduleRefreshBus._();

  static final ValueNotifier<int> signal = ValueNotifier<int>(0);

  static void notifyRefresh() {
    signal.value++;
  }
}
