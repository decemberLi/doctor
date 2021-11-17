package com.emedclouds.doctor

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import android.view.WindowManager
import cn.jpush.android.api.JPushInterface
import com.emedclouds.doctor.common.constants.keyLaunchParam
import com.emedclouds.doctor.common.document.DocumentViewActivity
import com.emedclouds.doctor.common.thirdpart.push.receiver.MessagePushReceiver
import com.emedclouds.doctor.common.thirdpart.report.appLaunch
import com.emedclouds.doctor.common.web.WebActivity
import com.emedclouds.doctor.common.web.pluginwebview.X5WebViewPlugin
import com.emedclouds.doctor.pages.ShareActivity
import com.emedclouds.doctor.pages.learningplan.LessonRecordActivity
import com.emedclouds.doctor.share.platform.Platform
import com.emedclouds.doctor.utils.*
import com.emedclouds.doctor.utils.OnFlutterCall.Companion.CHANNEL_RESULT_OK
import com.tencent.ocr.sdk.common.CustomConfigUi
import com.tencent.ocr.sdk.common.ISDKKitResultListener
import com.tencent.ocr.sdk.common.OcrSDKKit
import com.tencent.ocr.sdk.common.OcrType
import com.umeng.analytics.MobclickAgent
import com.umeng.cconfig.UMRemoteConfig
import com.umeng.cconfig.listener.OnConfigStatusChangedListener
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.renderer.FlutterUiDisplayListener
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject


class MainActivity : FlutterActivity() {
    private val tag = "MainActivity"
    private val mHandler = Handler()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        flutterEngine?.plugins?.add(X5WebViewPlugin())
        ChannelManager.instance.initChannel(flutterEngine?.dartExecutor)
        ChannelManager.instance.on("share", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): String {
                if (arguments == null) {
                    return CHANNEL_RESULT_OK
                }

                val jsonObject = JSONObject(arguments)
                ShareActivity.openShare(this@MainActivity, jsonObject.getString("path"), jsonObject.getString("url"), Platform.allPlatform)
                return CHANNEL_RESULT_OK
            }
        })
        ChannelManager.instance.on("record", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): String {
                if (arguments == null) {
                    return CHANNEL_RESULT_OK
                }
                val jsonObject = JSONObject(arguments)
                val path = jsonObject.getString("path")
                val name = jsonObject.getString("name")
                val userId = jsonObject.getString("userID")
                val hospital = jsonObject.getString("hospital")
                val title = jsonObject.getString("title")
                val type = jsonObject.getString("type")
                LessonRecordActivity.start(this@MainActivity, path, name, userId, hospital, title, type)
                return CHANNEL_RESULT_OK
            }

        })
        ChannelManager.instance.on("checkNotification", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                return NotificationUtil.isNotificationEnabled(this@MainActivity)
            }
        })
        ChannelManager.instance.on("openSetting", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                NotificationUtil.openNotificationSettingPage(this@MainActivity)
                return CHANNEL_RESULT_OK
            }
        })
        ChannelManager.instance.on("openWebPage", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                if (arguments == null) {
                    return CHANNEL_RESULT_OK
                }
                val json = JSONObject(arguments)
                val intent = Intent(this@MainActivity, WebActivity::class.java)
                intent.putExtra("url", json.getString("url"))
                intent.putExtra("title", json.getString("title"))
                startActivity(intent)
                return CHANNEL_RESULT_OK
            }
        })
        ChannelManager.instance.on("openFile", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                if (arguments == null) {
                    return CHANNEL_RESULT_OK
                }
                val json = JSONObject(arguments)
                DocumentViewActivity.open(this@MainActivity, json.getString("url"), json.getString("title"))
                return CHANNEL_RESULT_OK
            }
        })
        ChannelManager.instance.on("eventTracker", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                Log.d("Tracker.onEvent", "call: argument ->  $arguments")
                if (TextUtils.isEmpty(arguments)) {
                    return CHANNEL_RESULT_OK
                }
                JSONObject(arguments).apply {
                    val event = getString("eventName")
                    val ext = optString("ext")
                    val extMap: MutableMap<String, String> = HashMap<String, String>()
                    if (!TextUtils.isEmpty(ext)) {
                        val extJson = JSONObject(ext)
                        extJson.keys().forEach {
                            extMap[it] = "${extJson.get(it)}"
                        }
                    }
                    MobclickAgent.onEvent(application, event, extMap)
                }
                return CHANNEL_RESULT_OK
            }
        })
        ChannelManager.instance.on("login", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                refs(context).edit().apply {
                    putString(KEY_REFS_USER_ID, "$arguments")
                    apply()
                }
                MobclickAgent.onProfileSignIn("$arguments")
                return CHANNEL_RESULT_OK
            }
        })
        ChannelManager.instance.on("logout", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                refs(context).edit().apply {
                    remove(KEY_REFS_USER_ID)
                    apply()
                }
                MobclickAgent.onProfileSignOff()
                return CHANNEL_RESULT_OK
            }
        })

        goWebIfNeeded(intent)
        openNotificationIfNeeded(intent)
        flutterEngine?.renderer?.addIsDisplayingFlutterUiListener(object : FlutterUiDisplayListener {
            override fun onFlutterUiDisplayed() {
                Log.d("MainActivity", "onFlutterUiDisplayed")
                mHandler.postDelayed({
                    postJPushRegisterId()
                    openNotificationIfNeeded(intent)
                }, 2000)
            }

            override fun onFlutterUiNoLongerDisplayed() {
                Log.d("MainActivity", "onFlutterUiNoLongerDisplayed")
            }

        })
        ChannelManager.instance.on("ocrIdCardFaceSide", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                Log.d("TAG.Perm", "call: ${checkCameraPermission(application)}")
                OcrSDKKit.getInstance().startProcessOcr(this@MainActivity,
                        OcrType.IDCardOCR_FRONT,
                        CustomConfigUi().apply {
                            titleBarText = "扫描身份证"
                            remindDialogText = "未能识别证件，是否切换模式拍照上传?"
                        }, object : ISDKKitResultListener {
                    override fun onProcessSucceed(response: String, srcBase64Image: String, requestId: String) {
                        Log.d(tag, "onProcessSucceed: $response")
                        ocrCallback("ocrIdCardFaceSide", srcBase64Image, response)
                    }

                    override fun onProcessFailed(errorCode: String, message: String, requestId: String) {
                        Log.d(tag, "onProcessFailed: ")
                    }
                })
                return "OK"
            }
        });
        ChannelManager.instance.on("ocrBankCard", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                OcrSDKKit.getInstance().startProcessOcr(this@MainActivity,
                        OcrType.BankCardOCR,
                        CustomConfigUi().apply {
                            titleBarText = "扫描银行卡"
                            remindDialogText = "未能识别证件，是否切换模式拍照上传?"
                        }, object : ISDKKitResultListener {
                    override fun onProcessSucceed(response: String, srcBase64Image: String, requestId: String) {
                        Log.d(tag, "onProcessSucceed: $response")
                        ocrCallback("ocrBankCard", srcBase64Image, response)
                    }

                    override fun onProcessFailed(errorCode: String, message: String, requestId: String) {
                        Log.d(tag, "onProcessFailed: ")
                    }
                })
                return "OK"
            }
        });
        ChannelManager.instance.on("ocrIdCardBackSide", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                OcrSDKKit.getInstance().startProcessOcr(this@MainActivity,
                        OcrType.IDCardOCR_BACK,
                        CustomConfigUi().apply {
                            titleBarText = "扫描身份证"
                            remindDialogText = "未能识别证件，是否切换模式拍照上传?"
                        }, object : ISDKKitResultListener {
                    override fun onProcessSucceed(response: String, srcBase64Image: String, requestId: String) {
                        Log.d(tag, "onProcessSucceed: $response")
                        ocrCallback("ocrIdCardBackSide", srcBase64Image, response)
                    }

                    override fun onProcessFailed(errorCode: String, message: String, requestId: String) {
                        Log.d(tag, "onProcessFailed: ")
                    }
                })
                return "OK"
            }
        });
        ChannelManager.instance.on("brightness",object : OnFlutterCall{
            override fun call(arguments: String?, channel: MethodChannel): Any {
                return getBrightness()
            }
        })
        ChannelManager.instance.on("setBrightness",object : OnFlutterCall{
            override fun call(arguments: String?, channel: MethodChannel): Any {
                activity.window.attributes.screenBrightness = arguments?.toFloat() ?: 0f
                return true
            }
        })
        ChannelManager.instance.on("isKeptOn",object : OnFlutterCall{
            override fun call(arguments: String?, channel: MethodChannel): Any {
                val flags = activity.window.attributes.flags
                return (flags and WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) != 0
            }
        })
        ChannelManager.instance.on("keepOn",object : OnFlutterCall{
            override fun call(arguments: String?, channel: MethodChannel): Any {
                val keep = arguments == "1"
                if (keep){
                    activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                }else{
                    activity.window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                }
                return true
            }
        })
        ChannelManager.instance.on("getConfigValue", object : OnFlutterCall {
            override fun call(arguments: String?, channel: MethodChannel): Any {
                val config = UMRemoteConfig.getInstance().getConfigValue(arguments)
                com.umeng.cconfig.a.c.a(context).apply {
                    edit().remove("cconfig_sp_last_request_time").apply()
                }
                UMRemoteConfig.getInstance().setOnNewConfigfecthed(object : OnConfigStatusChangedListener {
                    override fun onFetchComplete() {
                    }

                    override fun onActiveComplete() {
                    }
                })
                UMRemoteConfig.getInstance().activeFetchConfig()
                return config ?: ""
            }
        })
//        CommonWebActivity.start(this@MainActivity, "", "http://192.168.1.27:9000/#/detail?id=283")
    }

    fun ocrCallback(type: String, srcBase64Image: String, response: String) {
        val filePath = ImageConvertUtil.base64ToFile(application, srcBase64Image, type)
        val json = JSONObject(response).apply {
            put("imgPath", filePath?.absolutePath)
        }
        ChannelManager.instance.callFlutter(type, json.toString(), MethodChannelResultAdapter())
    }


    override fun onDestroy() {
        super.onDestroy()
    }

    private fun postJPushRegisterId() {
        val json = JSONObject()
        json.put("registerId", JPushInterface.getRegistrationID(application))
        Log.d(tag, "postJPushRegisterId: $json")
        ChannelManager.instance.callFlutter("uploadDeviceInfo", json.toString(), object : MethodChannelResultAdapter() {})
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        goWebIfNeeded(intent)
        openNotificationIfNeeded(intent)
    }

    private fun goWebIfNeeded(intent: Intent?) {
        if (intent == null) {
            return
        }
        var ext: String? = intent.getStringExtra(keyLaunchParam)

        if (TextUtils.isEmpty(ext)) {
            ext = intent.dataString
        }

        if (ext == null) {
            return
        }
        appLaunch(context, 1)
        val parse = Uri.parse(ext)
        val extValue = parse.getQueryParameter("ext")
        if (extValue != null) {
            val recIntent = Intent(this@MainActivity, WebActivity::class.java)
            recIntent.putExtra("url", JSONObject(extValue).getString("url"))
            recIntent.putExtra("title", "")
            startActivity(recIntent)
        }
    }

    override fun onResume() {
        super.onResume()
        MobclickAgent.onResume(this)
    }

    override fun onPause() {
        super.onPause()
        MobclickAgent.onPause(this)
    }

    private fun openNotificationIfNeeded(intent: Intent?) {
        if (intent == null) {
            return
        }
        val extra = intent.getStringExtra("extras")
        if (extra == null) {
            return
        }
        try {
            if (!SystemUtil.isForeground(context)) {
                appLaunch(context, 0)
            }
            ChannelManager.instance.callFlutter("receiveNotification", extra,
                    object : MethodChannelResultAdapter() {
                        override fun success(result: Any?) {
                            Log.d(MessagePushReceiver.TAG, "Dispatch message success: [${extra}]")
                        }

                        override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                            Log.d(MessagePushReceiver.TAG, "Dispatch message failure: [${extra}]")
                        }

                        override fun notImplemented() {
                            Log.d(MessagePushReceiver.TAG, "Dispatch message failure, method not implemented")
                        }
                    })
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun getBrightness(): Float {
        var result: Float = activity.window.attributes.screenBrightness
        if (result < 0) { // the application is using the system brightness
            try {
                result = Settings.System.getInt(context.contentResolver, Settings.System.SCREEN_BRIGHTNESS) / 255.toFloat()
            } catch (e: Settings.SettingNotFoundException) {
                result = 1.0f
                e.printStackTrace()
            }
        }
        return result
    }

//    override fun finish() {
//        moveTaskToBack(true);
//    }
}
