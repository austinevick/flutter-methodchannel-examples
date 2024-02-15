package com.example.mysample

import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.hardware.camera2.CameraManager
import android.view.WindowManager.LayoutParams
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.mysample/methodchannel"
    private var counter = 0
    private lateinit var bluetoothAdapter: BluetoothAdapter
    private lateinit var cameraManager: CameraManager
    private lateinit var cameraId: String
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        cameraId = cameraManager.cameraIdList[0]
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "increment" -> {
                    try {
                        result.success(counter++)
                    } catch (e: NotImplementedError) {
                        result.notImplemented()
                    }
                }

                "decrement" -> {
                    try {
                        result.success(counter--)
                    } catch (e: NotImplementedError) {
                        result.notImplemented()
                    }
                }

                "disableScreenshot" -> {
                    try {
                        window.addFlags(LayoutParams.FLAG_SECURE)
                        result.success(true)
                    } catch (e: NotImplementedError) {
                        result.notImplemented()
                    }

                }

                "enableScreenshot" -> {
                    try {
                        window.clearFlags(LayoutParams.FLAG_SECURE)
                        result.success(false)
                    } catch (e: NotImplementedError) {
                        result.notImplemented()
                    }
                }

                "turnOnTorch" -> {
                    try {
                        result.success(cameraManager.setTorchMode(cameraId, true))
                    } catch (e: Exception) {
                        result.notImplemented()
                    }
                }

                "turnOffTorch" -> {
                    try {
                        result.success(cameraManager.setTorchMode(cameraId, false))
                    } catch (e: Exception) {
                        result.notImplemented()
                    }
                }

                "showToast" -> {
                    try {
                        val m = call.argument<String>("msg")
                        val dur = call.argument<Int>("dur")
                        val toast = dur?.let { Toast.makeText(this, m, it) }
                        if (toast != null) {
                            result.success(toast.show())
                        }
                    } catch (e: Exception) {
                        result.notImplemented()
                    }
                }

            }

        }
    }

}
