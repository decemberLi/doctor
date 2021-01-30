package com.emedclouds.doctor.common.web.api

import android.app.Activity
import android.util.Log
import android.webkit.JavascriptInterface
import com.crazecoder.openfile.utils.JsonUtil
import com.emedclouds.doctor.common.web.ApiManager
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.tencent.smtt.sdk.ValueCallback
import com.tencent.smtt.sdk.WebView
import org.json.JSONObject


data class JavaScriptRequest(
        val method: String,
        val dispatchType: String,
        val bizType: String,
        val jsonParam: String
)

interface OnJavaScriptCallResult {
    fun onSuccess(content: String)
    fun onError(errorCode: String, errorMsg: String)
}

class JsApiDispatcher(activity: Activity, webView: WebView) {

    companion object {
        val TAG = JsApiDispatcher::class.java.simpleName
        const val JsCallMethodName = "jsCall"
        const val nativeCallMethodName = "nativeCall"

    }

    private val mActivity: Activity = activity
    private val mWebView: WebView = webView
    private val mGson: Gson = Gson()

    /**
     * {
     *  'dispatchType':"jsCallNameMethod",
     *  'bizType':'callback js method',
     *  'param': { // request param
     *  }
     * }
     */
    @JavascriptInterface
    fun dispatch(params: String) {
        Log.d(TAG, "Receive JavaScript request, param -> [$params]")

        val request = Gson().fromJson<JavaScriptRequest>(params,
                JavaScriptRequest::class.java)

        ApiManager.instance.dispatch(request.method, request.jsonParam, object : OnJavaScriptCallResult {
            override fun onSuccess(content: String) {
                val result = "$nativeCallMethodName('${mGson.toJson(content)}')"
                mWebView.evaluateJavascript(result) {

                }
            }

            override fun onError(errorCode: String, errorMsg: String) {
                TODO("Not yet implemented")
            }
        })
    }

}