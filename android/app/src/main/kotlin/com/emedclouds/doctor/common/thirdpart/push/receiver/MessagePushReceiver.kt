package com.emedclouds.doctor.common.thirdpart.push.receiver

import android.content.Context
import android.util.Log
import cn.jpush.android.api.CustomMessage
import cn.jpush.android.service.JPushMessageReceiver

class MessagePushReceiver : JPushMessageReceiver() {
    companion object {
        const val tag = "PushSdk"
    }

    override fun onMessage(ctx: Context?, cMsg: CustomMessage?) {
        super.onMessage(ctx, cMsg)
        Log.w(tag, "Receive new message by Jpush, message: [${cMsg?.toString()}]")
    }

}