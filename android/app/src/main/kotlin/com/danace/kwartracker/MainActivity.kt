package com.danace.kwartracker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private const val CHANNEL = "com.danace.kwartracker/pltChannel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method.equals("helloWorld")) {
                    val textHw = helloWorld()
                    result.success(textHw)
                } else {
                    result.error("UNAVAILABLE", "NO TEXT", null)
                }
            }
    }

    private fun helloWorld(): String {
        return "Hello World"
    }
}
