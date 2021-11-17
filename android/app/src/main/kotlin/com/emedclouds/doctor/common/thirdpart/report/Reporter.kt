package com.emedclouds.doctor.common.thirdpart.report

import android.content.Context
import android.util.Log
import com.emedclouds.doctor.BuildConfig
import com.emedclouds.doctor.R
import com.umeng.cconfig.RemoteConfigSettings
import com.umeng.cconfig.UMRemoteConfig
import com.umeng.cconfig.listener.OnConfigStatusChangedListener
import com.umeng.commonsdk.UMConfigure

class Reporter {

    companion object {
        const val TAG = "Reporter.Meng"

        fun init(ctx: Context, channel: String) {
            UMConfigure.setLogEnabled(BuildConfig.DEBUG)
            //云配置手动更新代码逻辑
            UMRemoteConfig.getInstance().setConfigSettings(RemoteConfigSettings.Builder().setAutoUpdateModeEnabled(false).build())
            UMRemoteConfig.getInstance().setDefaults(R.xml.clouds_xml)
            UMRemoteConfig.getInstance().setOnNewConfigfecthed(object : OnConfigStatusChangedListener {
                override fun onFetchComplete() {
                    UMRemoteConfig.getInstance().activeFetchConfig()
                }

                override fun onActiveComplete() {
                }
            })
            Log.d(TAG, "init: channel -> $channel")
            UMConfigure.init(ctx, ctx.resources.getString(R.string.umeng_app_id), channel, UMConfigure.DEVICE_TYPE_PHONE, null)
        }
    }

}