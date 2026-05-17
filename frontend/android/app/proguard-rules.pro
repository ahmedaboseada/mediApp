-keep class **.zego.** { *; }
-keep class **.**.zego_zpns.** { *; }
// Keep Zego ZPNS FCM native classes to avoid ClassNotFound at runtime
-keep class im.zego.zpns_android_plugin_fcm.** { *; }
-keep class im.zego.zpns_flutter.** { *; }