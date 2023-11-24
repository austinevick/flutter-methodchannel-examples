package com.example.mysample

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.view.WindowManager.LayoutParams
class MainActivity: FlutterActivity() {
    private val CHANNEL ="samples.flutter.dev/counter"
    private var counter = 0

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "increment" -> {
                    try {
                        result.success(counter++)
                    }catch (e: NotImplementedError){
                        result.notImplemented()
                    }
                }
                "decrement" -> {
                    try {
                        result.success(counter--)
                    }catch (e: NotImplementedError){
                        result.notImplemented()
                    }
                }
                "disable" -> {
                    try {
                        window.addFlags(LayoutParams.FLAG_SECURE)
                        result.success(true)
                    }catch (e: NotImplementedError){
                        result.notImplemented()
                    }

                }
                "enable" -> {
                    try {
                        window.clearFlags(LayoutParams.FLAG_SECURE)
                        result.success(false)
                    }catch (e: NotImplementedError){
                        result.notImplemented()
                    }
                }
            }

        }
    }

}
