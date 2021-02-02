package com.emedclouds.doctor.common.thirdpart.push.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import cn.jpush.android.api.CustomMessage
import cn.jpush.android.api.JPushInterface
import cn.jpush.android.service.JPushMessageReceiver
import com.emedclouds.doctor.MainActivity
import com.emedclouds.doctor.utils.ChannelManager
import com.emedclouds.doctor.utils.MethodChannelResultAdapter
import com.emedclouds.doctor.utils.SystemUtil
import com.tencent.bugly.Bugly
import com.tencent.bugly.crashreport.BuglyLog
import org.json.JSONObject

class MessagePushReceiver : BroadcastReceiver() {
    companion object {
        val TAG = MessagePushReceiver::class.java.simpleName
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == JPushInterface.EXTRA_REGISTRATION_ID) {
            BuglyLog.d(TAG,"MessagePushReceiver#onReceive#cn.jpush.android.REGISTRATION_ID")
            val json = JSONObject()
            json.put("registerId", JPushInterface.getRegistrationID(context))
            ChannelManager.instance.callFlutter("uploadDeviceInfo", json.toString(), object : MethodChannelResultAdapter() {})
            return
        }
        val extra = intent?.extras?.getString(JPushInterface.EXTRA_EXTRA)
        Log.w(TAG, "onReceive ## Receive new message by JPush, message: [${intent?.toString()}]")
        if (extra == null) {
            return
        }
        val json = JSONObject(extra)
        if(!json.has("extras")){
            Log.w(TAG, "onReceive ## extras is null")
            return;
        }
        if(SystemUtil.isForeground(context)){
            Log.d(TAG, "onReceive: 非前台应用，启动 activity, context = $context")
            val openIntent = Intent(context, MainActivity::class.java)
            openIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context?.startActivity(openIntent)
        }
        ChannelManager.instance.callFlutter("receiveNotification", json.getString("extras"),
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