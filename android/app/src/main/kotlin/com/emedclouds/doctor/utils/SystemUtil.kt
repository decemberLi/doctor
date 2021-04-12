package com.emedclouds.doctor.utils

import android.app.ActivityManager
import android.app.ActivityManager.MOVE_TASK_WITH_HOME
import android.content.Context
import android.content.Context.ACTIVITY_SERVICE
import android.os.Process
import android.util.Log
import com.emedclouds.doctor.BuildConfig
import com.emedclouds.doctor.YYYApplication


class SystemUtil {

    companion object {
        const val TAG = "SystemUtil"
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

        fun setTopApp(context: Context): Boolean {
            if (isForeground(context)) {
                return true
            }
            //获取ActivityManager
            val activityManager = context.getSystemService(ACTIVITY_SERVICE) as ActivityManager

            //获得当前运行的task(任务)
            val taskInfoList = activityManager.getRunningTasks(100)
            for (taskInfo in taskInfoList) {
                //找到本应用的 task，并将它切换到前台
                if (taskInfo.topActivity!!.packageName == context.packageName) {
                    activityManager.moveTaskToFront(taskInfo.id, MOVE_TASK_WITH_HOME)
                    return true
                }
            }
            return false
        }

        fun getProcessName(ctx: Context): String? {
            val activityManager = ctx.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val processes: List<ActivityManager.RunningAppProcessInfo> = activityManager.runningAppProcesses
            for (processInfo in processes) {
                if (processInfo.pid == Process.myPid()) {
                    return processInfo.processName;
                }
            }
            return null
        }

        // true is main process otherwise false
        fun isAppMainProcess(ctx: Context): Boolean {
            val isMainProcess = BuildConfig.APPLICATION_ID == getProcessName(ctx);
            Log.d(TAG, "isMainProcess -> $isMainProcess")
            return isMainProcess
        }
    }
}