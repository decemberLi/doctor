package com.emedclouds.doctor

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.emedclouds.doctor.pages.ShareActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    val tag = "MainActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine?.dartExecutor, "share")
                .setMethodCallHandler { call, result ->
                    run {
                        val intent = Intent();
                        intent.setClass(activity,ShareActivity::class.java)
                        startActivity(intent)
                        val args = call.arguments;
                        Log.d(tag, "args => args")

                        result.success("OK");
                    }
                };
    }
}
