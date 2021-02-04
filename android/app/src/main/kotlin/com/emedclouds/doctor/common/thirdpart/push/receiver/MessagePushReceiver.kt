package com.emedclouds.doctor.common.thirdpart.push.receiver

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.PendingIntent.FLAG_UPDATE_CURRENT
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.SystemClock
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import cn.jpush.android.api.CustomMessage
import cn.jpush.android.api.JPushInterface
import cn.jpush.android.service.JPushMessageReceiver
import com.emedclouds.doctor.MainActivity
import com.emedclouds.doctor.R
import com.emedclouds.doctor.utils.ChannelManager
import com.emedclouds.doctor.utils.MethodChannelResultAdapter
import com.tencent.bugly.crashreport.BuglyLog
import org.json.JSONObject


class MessagePushReceiver : BroadcastReceiver() {
    companion object {
        val TAG = MessagePushReceiver::class.java.simpleName
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        try {
            if (JPushInterface.EXTRA_REGISTRATION_ID.equals(intent?.action)) {
                BuglyLog.d(TAG, "MessagePushReceiver#onReceive#cn.jpush.android.REGISTRATION_ID")
                val json = JSONObject()
                json.put("registerId", JPushInterface.getRegistrationID(context))
                ChannelManager.instance.callFlutter("uploadDeviceInfo", json.toString(), object : MethodChannelResultAdapter() {})
                return
            } else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent?.action)) {
                Log.d(TAG, "onReceive: ${intent?.getBundleExtra("extras").toString()}")
                intent?.extras?.apply {
                    val extraStr = getString(JPushInterface.EXTRA_EXTRA)
                    val content = getString(JPushInterface.EXTRA_MESSAGE)!!
                    val title = getString(JPushInterface.EXTRA_TITLE)!!
                    showNotification(context, title, content, extraStr)
                }
            }
        } catch (e: Exception) {
            BuglyLog.e(TAG, "ReceivePushMsg", e)
            e.printStackTrace()
        }
    }

    private fun showNotification(context: Context?, title: String, content: String, extraStr: String?) {
        val jumpIntent = Intent(context, MainActivity::class.java)
//        jumpIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK // or Intent.FLAG_ACTIVITY_CLEAR_TASK
        if (extraStr != null) {
            jumpIntent.putExtra("extras", JSONObject(extraStr).getString("extras"))
        }
        val pendingIntent = PendingIntent.getActivity(context, 0, jumpIntent, FLAG_UPDATE_CURRENT)
        val builder = NotificationCompat.Builder(context!!, "1")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(title)
                .setContentText(content)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)

        val notificationManager = NotificationManagerCompat.from(context)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //创建通知渠道
            val name: CharSequence = "易学术"
            val description = "易学术"
            val importance = NotificationManager.IMPORTANCE_DEFAULT //重要性级别 这里用默认的
            val mChannel = NotificationChannel("1", name, importance)
            mChannel.description = description //渠道描述
            mChannel.enableLights(false) //是否显示通知指示灯
            mChannel.enableVibration(false) //是否振动
            notificationManager.createNotificationChannel(mChannel) //创建通知渠道
        }
        notificationManager.notify(SystemClock.elapsedRealtime().toInt(), builder.build())
        Log.d(TAG, "showNotification: OK")
        return
    }

}


class FakeReceiver : JPushMessageReceiver() {
    override fun onMessage(p0: Context?, p1: CustomMessage?) {
        super.onMessage(p0, p1)
    }
}