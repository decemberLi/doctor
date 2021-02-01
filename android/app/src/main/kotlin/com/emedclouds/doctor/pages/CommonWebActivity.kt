package com.emedclouds.doctor.pages

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.text.TextUtils
import android.widget.ImageView
import android.widget.TextView
import androidx.activity.ComponentActivity
import com.emedclouds.doctor.R
import com.emedclouds.doctor.common.web.YWebView
import com.emedclouds.doctor.common.web.api.JsApiCaller
import com.emedclouds.doctor.common.web.api.NativeApiProvider
import com.tencent.smtt.sdk.WebChromeClient
import com.tencent.smtt.sdk.WebSettings
import com.tencent.smtt.sdk.WebView

class CommonWebActivity : ComponentActivity() {

    private lateinit var mWebView: YWebView
    private lateinit var mTitleView: TextView

    companion object {
        const val keyTitle = "keyTitle"
        const val keyUrl = "keyUrl"
        fun start(activity: Activity, title: String, url: String) {
            val intent = Intent(activity, CommonWebActivity::class.java)
            intent.putExtra(keyTitle, title)
            intent.putExtra(keyUrl, url)
            activity.startActivity(intent)
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_common_web_layout)
        mWebView = findViewById(R.id.common_web)
        mTitleView = findViewById(R.id.tvTitle)
        findViewById<ImageView>(R.id.btnBack).setOnClickListener {
            finish()
        }

        val webSetting: WebSettings = mWebView.settings
        webSetting.setUserAgent("${webSetting.userAgentString} Medclouds-doctor")
        webSetting.javaScriptEnabled = true
        webSetting.domStorageEnabled = true
        mWebView.webChromeClient = object : WebChromeClient() {
            override fun onReceivedTitle(p0: WebView?, title: String?) {
                super.onReceivedTitle(p0, title)
                if (TextUtils.isEmpty(title)) {
                    return
                }
                mTitleView.text = title
            }

        }

        mWebView.addJavascriptInterface(NativeApiProvider(this, JsApiCaller(this, mWebView)), "jsCall")
        mWebView.loadUrl(intent.getStringExtra(keyUrl))
    }
}