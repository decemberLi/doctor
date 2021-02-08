package com.emedclouds.doctor.common.thirdpart.push.receiver

import android.content.Context
import cn.jpush.android.api.JPushInterface
import com.emedclouds.doctor.BuildConfig

class PushSdk {

    companion object {
        fun init(ctx: Context) {
            JPushInterface.setDebugMode(BuildConfig.DEBUG);
            JPushInterface.init(ctx)
            
        }
    }
}