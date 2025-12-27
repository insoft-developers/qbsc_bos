package com.qbsc.bos

import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "security/developer_mode"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // 🔥 WAJIB: register semua plugin (TERMASUK WebView)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "isDeveloperMode") {
                val isDevMode = Settings.Secure.getInt(
                    contentResolver,
                    Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
                    0
                ) == 1
                result.success(isDevMode)
            } else {
                result.notImplemented()
            }
        }
    }
}
