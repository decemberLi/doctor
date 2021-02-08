package com.emedclouds.doctor

import android.app.Application
import android.content.Context
import androidx.multidex.MultiDex
import com.emedclouds.doctor.common.thirdpart.apm.APM
import com.emedclouds.doctor.common.thirdpart.push.receiver.PushSdk
import com.emedclouds.doctor.common.thirdpart.report.Reporter
import io.flutter.app.FlutterApplication

class YYYApplication : FlutterApplication() {

    companion object {
        var context: Application? = null
    }

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(base)
    }


    override fun onCreate() {
        super.onCreate()
        context = this
        APM.init(applicationContext, resources.getString(R.string.bugly_app_id))
        Reporter.init(applicationContext, "developer")
        PushSdk.init(this)
    }
}