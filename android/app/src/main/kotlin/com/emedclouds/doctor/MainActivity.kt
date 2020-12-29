package com.emedclouds.doctor

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.emedclouds.doctor.common.constants.keyLaunchParam
import com.emedclouds.doctor.pages.ShareActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.renderer.FlutterUiDisplayListener
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    val tag = "MainActivity"
    lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        methodChannel = MethodChannel(flutterEngine?.dartExecutor, "com.emedclouds-channel/navigation");
        methodChannel.setMethodCallHandler { call, result ->
            run {
                val intent = Intent();
                intent.setClass(activity, ShareActivity::class.java)
                startActivity(intent)
                val args = call.arguments;
                Log.d(tag, "args => args")

                result.success("OK");
            }
        }
        flutterEngine?.renderer?.addIsDisplayingFlutterUiListener(object : FlutterUiDisplayListener {
            override fun onFlutterUiDisplayed() {
                if (intent == null) {
                    return;
                }
                val ext = intent.getStringExtra(keyLaunchParam)
                if (intent.getStringExtra(keyLaunchParam) != null) {
                    methodChannel.invokeMethod("commonWeb", ext)
                }
                if (intent.dataString != null) {
                    methodChannel.invokeMethod("commonWeb", intent.dataString)
                }
            }

            override fun onFlutterUiNoLongerDisplayed() {
            }

        })
    }
}
