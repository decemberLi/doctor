package com.emedclouds.doctor.common.thirdpart.apm

import android.content.Context
import com.emedclouds.doctor.BuildConfig
import com.tencent.bugly.crashreport.CrashReport
import com.tencent.bugly.crashreport.CrashReport.CrashHandleCallback

class APM {

    companion object {
        fun init(ctx: Context, appId: String,channel: String) {
            val strategy = CrashReport.UserStrategy(ctx).apply {
                appVersion = BuildConfig.VERSION_NAME
                appPackageName = BuildConfig.APPLICATION_ID
                appReportDelay = 1000
                appChannel = channel
                setCrashHandleCallback(object : CrashHandleCallback() {

                    override fun onCrashHandleStart(p0: Int, p1: String?, p2: String?, p3: String?): MutableMap<String, String> {
                        return super.onCrashHandleStart(p0, p1, p2, p3)
                    }

                    override fun onCrashHandleStart2GetExtraDatas(p0: Int, p1: String?, p2: String?, p3: String?): ByteArray {
                        return super.onCrashHandleStart2GetExtraDatas(p0, p1, p2, p3)
                    }

                })
            }
            CrashReport.setIsDevelopmentDevice(ctx, BuildConfig.DEBUG)

            CrashReport.initCrashReport(ctx, appId, BuildConfig.DEBUG, strategy)
        }
    }

}