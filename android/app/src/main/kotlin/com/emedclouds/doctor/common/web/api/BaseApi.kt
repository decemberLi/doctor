package com.emedclouds.doctor.common.web.api

import android.app.Activity
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.tencent.smtt.sdk.WebView


abstract class BaseApi(private val mApiCaller: JsApiCaller) {
    abstract fun doAction(bizType: String, param: String?)

    fun jsCall(bizType: String, content: String?) {
        // 优化项，可以将某些执行操作放在线程中执行
        // 添加签权逻辑
//        val param = Gson().fromJson<T>(content, object : TypeToken<T>() {}.type)
        doAction(bizType, content)
    }

    fun successCallJavaScript(bizType: String, content: Any) {
        mApiCaller.successCall(bizType, content)
    }

    protected fun errorCallJavaScript(bizType: String, errorCode: Int, errorMsg: String) {
        mApiCaller.errorCall(bizType, errorCode, errorMsg)
    }

}



