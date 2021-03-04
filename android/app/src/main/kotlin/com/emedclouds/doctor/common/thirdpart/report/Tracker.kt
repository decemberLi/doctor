package com.emedclouds.doctor.common.thirdpart.report

import android.content.Context
import android.util.Log
import com.emedclouds.doctor.utils.refs
import com.umeng.analytics.MobclickAgent

const val EVENT_APP_LAUNCH = "app_launch"


fun appLaunch(
        context: Context,
        source: Int
) {
    Log.d("Tracker.Launch", "appLaunch: source -> $source")
    val isFirst = refs(context).getBoolean("isFirst", true)
    MobclickAgent.onEvent(context, EVENT_APP_LAUNCH, HashMap<String, String>().apply {
        put("launch_sourse", "$source")
        put("is_first", if (isFirst) {
            "1"
        } else {
            "0"
        })
    })
    refs(context).edit().putBoolean("isFirst", false).apply()
}