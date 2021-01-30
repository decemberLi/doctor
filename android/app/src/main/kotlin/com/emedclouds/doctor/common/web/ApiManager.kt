package com.emedclouds.doctor.common.web

import com.emedclouds.doctor.common.web.api.JsApi
import com.emedclouds.doctor.common.web.api.OnJavaScriptCallResult

class ApiManager {

    private val mApiMap: MutableMap<String, JsApi> = hashMapOf()

    companion object {
        var instance = Holder.holder
    }

    private object Holder {
        val holder = ApiManager()
    }

    fun addApi(name: String, api: JsApi) {
        mApiMap[name] = api
    }

    fun removeApi(name: String): JsApi? {
        return mApiMap.remove(name)
    }

    fun dispatch(name: String, param: String, callback: OnJavaScriptCallResult) {
        val jsApi = mApiMap[name]
        if (jsApi == null) {
            callback.onError("-1", "method not implementation")
            return
        }

        jsApi.javaScriptCallNative(param);
    }

}