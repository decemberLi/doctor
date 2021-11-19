package com.emedclouds.doctor.common.thirdpart.report

import android.content.Context
import android.util.Log
import com.emedclouds.doctor.BuildConfig
import com.emedclouds.doctor.R
import com.umeng.commonsdk.UMConfigure

class Reporter {

    companion object {
        const val TAG = "Reporter"

        fun init(ctx: Context,channel:String) {
            UMConfigure.setLogEnabled(BuildConfig.DEBUG)
            Log.d(TAG, "init: channel -> $channel")
            UMConfigure.init(ctx, ctx.resources.getString(R.string.umeng_app_id), channel, UMConfigure.DEVICE_TYPE_PHONE, "")
        }
    }

}