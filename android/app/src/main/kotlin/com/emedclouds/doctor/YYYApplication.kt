package com.emedclouds.doctor

import android.app.Application
import android.content.Context
import android.util.Log
import com.emedclouds.doctor.common.thirdpart.apm.APM
import com.emedclouds.doctor.common.thirdpart.push.receiver.PushSdk
import com.emedclouds.doctor.common.thirdpart.report.Reporter
import com.emedclouds.doctor.common.thirdpart.report.appLaunch
import com.emedclouds.doctor.utils.PackerNg
import com.emedclouds.doctor.utils.SystemUtil.Companion.isAppMainProcess
import com.tencent.ocr.sdk.common.OcrModeType
import com.tencent.ocr.sdk.common.OcrSDKConfig
import com.tencent.ocr.sdk.common.OcrSDKKit
import com.tencent.ocr.sdk.common.OcrType
import com.tencent.smtt.export.external.TbsCoreSettings
import com.tencent.smtt.sdk.QbSdk
import com.tencent.smtt.sdk.QbSdk.PreInitCallback
import io.flutter.app.FlutterApplication
import java.util.*

class YYYApplication : FlutterApplication() {

    companion object {
        const val TAG = "YYYApplication"
        var context: Application? = null
    }

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        if(!isAppMainProcess(this)){
            return
        }
    }


    override fun onCreate() {
        super.onCreate()
        if(!isAppMainProcess(this)){
            return
        }
        context = this
        val apkChannelName = PackerNg.getChannel(this)
        APM.init(applicationContext, resources.getString(R.string.bugly_app_id), apkChannelName)
        Reporter.init(applicationContext, apkChannelName)
        PushSdk.init(this)
        initQbSdk();
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

    private fun initQbSdk() {
        // 首次初始化冷启动优化
        // 在调用TBS初始化、创建WebView之前进行如下配置
        val map: HashMap<String, Any> = HashMap<String, Any>()
        map[TbsCoreSettings.TBS_SETTINGS_USE_SPEEDY_CLASSLOADER] = true
        map[TbsCoreSettings.TBS_SETTINGS_USE_DEXLOADER_SERVICE] = true
        QbSdk.initTbsSettings(map)
        QbSdk.setDownloadWithoutWifi(true)
        QbSdk.initX5Environment(context, object : PreInitCallback {
            override fun onCoreInitFinished() {
                //x5内核初始化完成回调接口，此接口回调并表示已经加载起来了x5，有可能特殊情况下x5内核加载失败，切换到系统内核。
                Log.d(TAG, "初始化X5成功")
            }

            override fun onViewInitFinished(b: Boolean) {
                //x5內核初始化完成的回调，为true表示x5内核加载成功，否则表示x5内核加载失败，会自动切换到系统内核。
                Log.e(TAG, "加载内核是否成功:$b")
            }
        })
    }

}