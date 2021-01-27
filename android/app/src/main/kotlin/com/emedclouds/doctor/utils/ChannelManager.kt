package com.emedclouds.doctor.utils

import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

interface OnFlutterCall {
    fun call(arguments: String?, channel: MethodChannel)
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
            run {
                mMap[call.method]?.call(call.arguments as String, mMethodChannel)
                Log.d(TAG, "Flutter call Native method -> [${call.arguments}], args -> [${call.arguments}]")
                result.success("OK")
            }
        }
    }

    fun on(method: String, caller: OnFlutterCall) {
        mMap[method] = caller
    }

    fun callFlutter(method: String, arguments: String, callback: MethodChannel.Result) {
        mMethodChannel.invokeMethod(method, arguments, callback)
    }

}

open class MethodChannelResultAdapter : MethodChannel.Result{
    override fun success(result: Any?) {
    }

    override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
    }

    override fun notImplemented() {
    }

}