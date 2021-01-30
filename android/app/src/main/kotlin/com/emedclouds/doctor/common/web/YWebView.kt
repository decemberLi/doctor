package com.emedclouds.doctor.common.web

import android.content.Context
import android.util.AttributeSet
import android.util.Log
import android.view.KeyEvent
import android.view.View
import com.emedclouds.doctor.common.web.YWebViewHelper.Companion.configWebViewSetting
import com.emedclouds.doctor.common.web.YWebViewHelper.Companion.yWebWorkFolder
import com.tencent.smtt.export.external.interfaces.*
import com.tencent.smtt.sdk.WebChromeClient
import com.tencent.smtt.sdk.WebView
import com.tencent.smtt.sdk.WebViewClient

class YWebView : WebView {

    constructor(context: Context) : this(context, null)

    constructor(context: Context, attributes: AttributeSet?) :
            this(context, attributes, 0)

    constructor(context: Context, attributes: AttributeSet?, defStyleAttr: Int) :
            this(context, attributes, defStyleAttr, false)

    constructor(context: Context, attributes: AttributeSet?, defStyleAttr: Int, flag: Boolean) :
            super(context, attributes, defStyleAttr, flag) {
        yWebWorkFolder(context)
        configWebViewSetting(context, this)
    }

}