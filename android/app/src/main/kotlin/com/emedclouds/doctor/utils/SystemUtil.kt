package com.emedclouds.doctor.utils

import android.app.ActivityManager
import android.content.Context

class SystemUtil {

    companion object {
        fun isForeground(context: Context?): Boolean {
            if (context != null) {
                val activityManager: ActivityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                val processes: List<ActivityManager.RunningAppProcessInfo> = activityManager.getRunningAppProcesses()
                for (processInfo in processes) {
                    if (processInfo.processName.equals(context.getPackageName())) {
                        return processInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
                    }
                }
            }
            return false
        }
    }
}