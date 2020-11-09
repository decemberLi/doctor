package com.emedclouds.doctor

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class YYYApplication : FlutterApplication() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(base);
    }
}