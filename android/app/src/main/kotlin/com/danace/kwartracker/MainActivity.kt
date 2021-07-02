package com.danace.kwartracker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    val CHANNEL = "com.danace.kwartracker/pltChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
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
