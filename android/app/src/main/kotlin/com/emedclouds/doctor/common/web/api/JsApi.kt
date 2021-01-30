package com.emedclouds.doctor.common.web.api


interface JsApi {

    fun javaScriptCallNative(jsonParam: String)

    fun nativeCallJavascript(content: String)

}



