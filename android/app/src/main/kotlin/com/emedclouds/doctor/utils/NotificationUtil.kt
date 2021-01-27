package com.emedclouds.doctor.utils

import android.annotation.SuppressLint
import android.app.AppOpsManager
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import java.lang.reflect.Field
import java.lang.reflect.Method

/**
 *
 * Created by lcq on 2021/1/24.
 */
class NotificationUtil {
    companion object {
        private const val CHECK_OP_NO_THROW = "checkOpNoThrow"
        private const val OP_POST_NOTIFICATION = "OP_POST_NOTIFICATION"

        @SuppressLint("NewApi")
        fun isNotificationEnabled(context: Context): Boolean {
//            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
//                return true
//            }
//
//            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O) {
//                return isEnableV19(context)
//            } else {
//                return isEnableV26(context)
//            }
            return NotificationManagerCompat.from(context).areNotificationsEnabled()
        }

        private fun isEnableV19(context: Context): Boolean {
            val mAppOps: AppOpsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val appInfo: ApplicationInfo = context.applicationInfo
            val pkg: String = context.applicationContext.packageName
            val uid: Int = appInfo.uid
            var appOpsClass: Class<*>? = null
            /* Context.APP_OPS_MANAGER */
            try {
                appOpsClass = Class.forName(AppOpsManager::class.java.name)
                val method: Method = appOpsClass.getMethod(CHECK_OP_NO_THROW,
                        Integer.TYPE, Integer.TYPE, String::class.java)
                val opPostNotificationValue: Field = appOpsClass.getDeclaredField(OP_POST_NOTIFICATION)
                val value = opPostNotificationValue.get(Int::class.java) as Int
                val isPermissionGranted = method.invoke(mAppOps, value, uid, pkg) as Int
                return isPermissionGranted == AppOpsManager.MODE_ALLOWED
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return false
        }

        private fun isEnableV26(context: Context): Boolean {
            val appInfo = context.applicationInfo
            val pkg = context.applicationContext.packageName
            val uid = appInfo.uid
            return try {
                val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                val sServiceField: Method = notificationManager.javaClass.getDeclaredMethod("getService")
                sServiceField.isAccessible = true
                val sService = sServiceField.invoke(notificationManager)
                val method = sService.javaClass.getDeclaredMethod("areNotificationsEnabledForPackage", String::class.java, Integer.TYPE)
                method.isAccessible = true
                method.invoke(sService, pkg, uid) as Boolean
            } catch (e: java.lang.Exception) {
                true
            }
        }

        fun openNotificationSettingPage(ctx: Context) {
            val intent = Intent()
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            intent.action = "android.settings.APPLICATION_DETAILS_SETTINGS"
            intent.data = Uri.fromParts("package", ctx.packageName, null)
            ctx.startActivity(intent)
        }
    }

}