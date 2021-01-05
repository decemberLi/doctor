package com.emedclouds.doctor

import android.content.Context
import androidx.multidex.MultiDex
import com.emedclouds.doctor.common.thirdpart.apm.APM
import com.emedclouds.doctor.common.thirdpart.push.receiver.PushSdk
import com.emedclouds.doctor.common.thirdpart.report.Reporter
import io.flutter.app.FlutterApplication

class YYYApplication : FlutterApplication() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(base)
    }


    override fun onCreate() {
        super.onCreate()
        APM.init(applicationContext, resources.getString(R.string.bugly_app_id))
        Reporter.init(applicationContext, "developer")
        PushSdk.init(this)
    }
}