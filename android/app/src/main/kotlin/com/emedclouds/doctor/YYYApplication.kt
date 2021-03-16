package com.emedclouds.doctor

import android.app.Application
import android.content.Context
import android.util.Log
import androidx.multidex.MultiDex
import com.emedclouds.doctor.common.thirdpart.apm.APM
import com.emedclouds.doctor.common.thirdpart.push.receiver.PushSdk
import com.emedclouds.doctor.common.thirdpart.report.Reporter
import com.emedclouds.doctor.common.thirdpart.report.appLaunch
import com.emedclouds.doctor.utils.PackerNg
import com.emedclouds.doctor.utils.SystemUtil
import com.tencent.ocr.sdk.common.OcrModeType
import com.tencent.ocr.sdk.common.OcrSDKConfig
import com.tencent.ocr.sdk.common.OcrSDKKit
import com.tencent.ocr.sdk.common.OcrType
import io.flutter.app.FlutterApplication

class YYYApplication : FlutterApplication() {

    companion object {
        const val TAG = "YYYApplication"
        var context: Application? = null
    }

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        Log.d(TAG, "attachBaseContext: ${SystemUtil.getProcessName(this)}")
        if (BuildConfig.APPLICATION_ID != SystemUtil.getProcessName(this)) {
            return
        }
        MultiDex.install(base)
    }


    override fun onCreate() {
        super.onCreate()
        context = this
        val apkChannelName = PackerNg.getChannel(this)
        APM.init(applicationContext, resources.getString(R.string.bugly_app_id), apkChannelName)
        Reporter.init(applicationContext, apkChannelName)
        PushSdk.init(this)
        tencentOcr()
    }

    private fun tencentOcr() {
        // 设置默认的业务识别模式自动 + 手动步骤模式
        val modeType: OcrModeType = OcrModeType.OCR_DETECT_AUTO_MANUAL
        // 设置默认的业务识别，银行卡
        val ocrType: OcrType = OcrType.BankCardOCR
        val configBuilder: OcrSDKConfig = OcrSDKConfig.newBuilder("AKIDKSP1OXP1ytJTNWQ9tOfhUflmrgJgGIjw", "BLFuJeIXIwHVsqjBOt4Cm7B9VihQt6SZ", null)
                .ocrType(ocrType)
                .setModeType(modeType)
                .build()
        // 初始化 SDK
        OcrSDKKit.getInstance().initWithConfig(this.applicationContext, configBuilder)
        appLaunch(this, -1)
    }
}