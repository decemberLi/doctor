package com.emedclouds.doctor

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.emedclouds.doctor.common.constants.keyLaunchParam
import com.emedclouds.doctor.pages.ShareActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.renderer.FlutterUiDisplayListener
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val tag = "MainActivity"
    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        methodChannel = MethodChannel(flutterEngine?.dartExecutor, "com.emedclouds-channel/navigation")
        methodChannel.setMethodCallHandler { call, result ->
            run {
                if ("share" == call.method) {
                    if (call.arguments == null || call.arguments !is String) {
                        return@run
                    }
                    Log.d(tag, String.format("Open share page, args [%s]", call.arguments))

                    val jsonObject = JSONObject(call.arguments as String)
                    ShareActivity.openShare(this@MainActivity, jsonObject.getString("path"), jsonObject.getString("url"))
                }
                result.success("OK")
            }
        }
        flutterEngine?.renderer?.addIsDisplayingFlutterUiListener(listener);
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        flutterEngine?.renderer?.addIsDisplayingFlutterUiListener(listener)
    }

    val listener = object : FlutterUiDisplayListener {
        override fun onFlutterUiDisplayed() {
            if (intent == null) {
                return
            }
            val ext = intent.getStringExtra(keyLaunchParam)
            if (intent.getStringExtra(keyLaunchParam) != null) {
                methodChannel.invokeMethod("commonWeb", ext)
            }
            if (intent.dataString != null) {
                methodChannel.invokeMethod("commonWeb", intent.dataString)
            }
            flutterEngine?.renderer?.removeIsDisplayingFlutterUiListener(this)
        }

        override fun onFlutterUiNoLongerDisplayed() {
        }

    }
}
