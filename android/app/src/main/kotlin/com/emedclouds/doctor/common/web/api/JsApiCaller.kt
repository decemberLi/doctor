package com.emedclouds.doctor.common.web.api

import android.app.Activity
import android.util.Log
import com.emedclouds.doctor.common.web.YWebView
import org.json.JSONObject

class JsApiCaller(private val activity: Activity, private val mWebView: YWebView) {

    private val TAG = "YWebView.JsApiCaller"
    fun successCall(bizType: String, content: Any) {
        callJs(commonResult(bizType, content = content))
    }

    fun errorCall(bizType: String, errorCode: Int, errorMsg: String) {
        callJs(commonResult(bizType = bizType, code = errorCode, content = errorMsg))
    }

    private fun commonResult(bizType: String, code: Int = 0, content: Any): String {
        return JSONObject().apply {
            put("bizType", bizType)
            put("param",
                    JSONObject().apply {
                        put("code", code)
                        put("content", content)
                    }
            )
        }.toString()
    }

    private fun callJs(content: String) {
        Log.d(TAG, "callJs: $content")
        activity.runOnUiThread {
            mWebView.evaluateJavascript("nativeCall('${content}')") {
            }
        }
    }

}