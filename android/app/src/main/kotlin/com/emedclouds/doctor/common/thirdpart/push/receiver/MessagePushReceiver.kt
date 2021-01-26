package com.emedclouds.doctor.common.thirdpart.push.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import cn.jpush.android.api.CustomMessage
import cn.jpush.android.api.JPushInterface
import cn.jpush.android.service.JPushMessageReceiver
import com.emedclouds.doctor.utils.ChannelManager
import com.emedclouds.doctor.utils.MethodChannelResultAdapter

class MessagePushReceiver : BroadcastReceiver() {
    companion object {
        val TAG = MessagePushReceiver::class.java.simpleName
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        val extra = intent?.extras?.getString(JPushInterface.EXTRA_EXTRA)
        Log.w(TAG, "onReceive ## Receive new message by JPush, message: [${intent?.toString()}]")
        if (extra == null) {
            return
        }
        ChannelManager.instance.callFlutter("receiveNotification", extra,
                object : MethodChannelResultAdapter() {
                    override fun success(result: Any?) {
                        Log.d(TAG, "Dispatch message success: [${extra}]")
                    }

                    override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                        Log.d(TAG, "Dispatch message failure: [${extra}]")
                    }

                    override fun notImplemented() {
                        Log.d(TAG, "Dispatch message failure, method not implemented")
                    }
                })
    }

}


class FakeReceiver : JPushMessageReceiver() {
    override fun onMessage(p0: Context?, p1: CustomMessage?) {
        super.onMessage(p0, p1)
    }
}