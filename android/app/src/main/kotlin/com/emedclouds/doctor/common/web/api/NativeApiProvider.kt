package com.emedclouds.doctor.common.web.api

import android.app.Activity
import android.util.Log
import android.webkit.JavascriptInterface
import androidx.annotation.Keep
import com.emedclouds.doctor.common.web.ApiManager
import com.emedclouds.doctor.common.web.DispatchException
import com.google.gson.Gson


data class JavaScriptRequest(
        val dispatchType: String,
        val bizType: String,
        val param: Any?
)

class NativeApiProvider(private val activity: Activity, private val apiCaller: JsApiCaller) {

    companion object {
        private const val TAG = "YWeb.NativeApiProvider"
    }

    /**
     * {
     *  'dispatchType':"jsCallNameMethod",
     *  'bizType':'callback js method',
     *  'param': { // request param
     *  }
     * }
     */
    @Keep
    @JavascriptInterface
    fun postMessage(params: String) {
        Log.d(TAG, "Receive JavaScript request, param -> $params")

        val request = Gson().fromJson<JavaScriptRequest>(params,
                JavaScriptRequest::class.java)
        activity.runOnUiThread {
            try {
                ApiManager.instance.dispatch(request.dispatchType, request.bizType, Gson().toJson(request.param).toString())
            } catch (e: DispatchException) {
                e.printStackTrace()
                apiCaller.errorCall(request.bizType, e.code(), e.msg())
            } catch (e: Exception) {
                e.printStackTrace()
                Log.e(TAG, "postMessage: ", e)
                apiCaller.errorCall(request.bizType, -1, "UNKNOWN_ERROR")
            }
        }
    }

}