package com.emedclouds.doctor

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import com.emedclouds.doctor.common.constants.keyLaunchParam
import com.emedclouds.doctor.pages.CommonWebActivity
import com.emedclouds.doctor.pages.ShareActivity
import com.umeng.analytics.MobclickAgent
import io.flutter.embedding.android.FlutterActivity
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
        goWebIfNeeded(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        goWebIfNeeded(intent)
    }

    private fun goWebIfNeeded(intent: Intent?) {
        if (intent == null) {
            return
        }
        var ext: String? = intent.getStringExtra(keyLaunchParam)

        if (TextUtils.isEmpty(ext)) {
            ext = intent.dataString
        }

        if (ext == null) {
            return
        }

        val parse = Uri.parse(ext)
        val extValue = parse.getQueryParameter("ext");
        if (extValue != null) {
            val url = JSONObject(extValue).getString("url")
            CommonWebActivity.start(this@MainActivity, "", url)
        }
    }

    override fun onResume() {
        super.onResume()
        MobclickAgent.onResume(this)
    }

    override fun onPause() {
        super.onPause()
        MobclickAgent.onPause(this)
    }
}
