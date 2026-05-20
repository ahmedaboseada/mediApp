package com.example.medi

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val channelName = "medi/system_settings"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(
			flutterEngine.dartExecutor.binaryMessenger,
			channelName,
		).setMethodCallHandler { call, result ->
			when (call.method) {
				"isNotificationPolicyAccessGranted" -> {
					val notificationManager =
						getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
					result.success(notificationManager.isNotificationPolicyAccessGranted)
				}

				"openNotificationPolicyAccessSettings" -> {
					val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
						.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
					startActivity(intent)
					result.success(true)
				}

				"isIgnoringBatteryOptimizations" -> {
					if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
						result.success(true)
					} else {
						val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
						result.success(powerManager.isIgnoringBatteryOptimizations(packageName))
					}
				}

				"openIgnoreBatteryOptimizationSettings" -> {
					if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
						result.success(true)
					} else {
						val intent = Intent(
							Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
							Uri.parse("package:$packageName"),
						).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

						try {
							startActivity(intent)
						} catch (_: Exception) {
							startActivity(
								Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
									.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
							)
						}
						result.success(true)
					}
				}

				else -> result.notImplemented()
			}
		}
	}
}
