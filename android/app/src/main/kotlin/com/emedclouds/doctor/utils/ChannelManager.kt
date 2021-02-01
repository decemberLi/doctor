package com.emedclouds.doctor.utils

import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

interface OnFlutterCall {
    companion object {
        const val CHANNEL_RESULT_OK = "OK"
    }

    fun call(arguments: String?, channel: MethodChannel): Any
}

class ChannelManager {
    private lateinit var mMethodChannel: MethodChannel
    private val mMap: HashMap<String, OnFlutterCall> = HashMap()

    companion object {
        private val TAG = ChannelManager::class.java.simpleName
        val instance by lazy(LazyThreadSafetyMode.NONE) {
            ChannelManager()
        }

    }

    fun initChannel(messenger: BinaryMessenger?) {
        mMethodChannel = MethodChannel(messenger, "com.emedclouds-channel/navigation")
        mMethodChannel.setMethodCallHandler { call, result ->
            var arguments = ""
            if (call.arguments != null) {
                arguments = call.arguments as String
            }
            val retValue = mMap[call.method]?.call(arguments, mMethodChannel)
            Log.d(TAG, "Flutter call Native method -> [${call.arguments}], args -> [${call.arguments}]")
            result.success(retValue)
        }
    }

    fun on(method: String, caller: OnFlutterCall) {
        mMap[method] = caller
    }

    fun callFlutter(method: String, arguments: String, callback: MethodChannel.Result) {
        mMethodChannel.invokeMethod(method, arguments, callback)
    }

}

open class MethodChannelResultAdapter : MethodChannel.Result {
    private val TAG = MethodChannelResultAdapter::class.java.simpleName
    override fun success(result: Any?) {
        Log.d(TAG, "success: result -> $result")
    }

    override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
        Log.d(TAG, "error: errorCode: $errorCode, errorMessage $errorMessage, errorDetails: $errorDetails")
    }

    override fun notImplemented() {
        Log.d(TAG, "notImplemented")
    }

}