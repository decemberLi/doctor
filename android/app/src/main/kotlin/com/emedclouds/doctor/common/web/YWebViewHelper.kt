package com.emedclouds.doctor.common.web

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
import com.emedclouds.doctor.BuildConfig
import com.tencent.smtt.sdk.CookieManager
import com.tencent.smtt.sdk.WebSettings
import com.tencent.smtt.sdk.WebView
import java.io.File
import java.io.IOException

class YWebViewHelper {

    companion object {
        const val WEB_VIEW_WORK_DIR = "yWeb"

        fun yWebWorkFolder(ctx: Context): String? {
            val apply = ctx.getExternalFilesDir(WEB_VIEW_WORK_DIR)?.apply {
                if (!exists() && (!mkdirs())) {
                    throw IOException("Create Web work folder failure.")
                }
            }

            return apply?.absolutePath
        }

        fun appCachePath(ctx: Context): String? {
            if (yWebWorkFolder(ctx) == null) {
                return null
            }

            val file = File(yWebWorkFolder(ctx), "yWebAppCache")
            if (!file.exists() && (!file.mkdirs())) {
                return null
            }

            return file.absolutePath
        }

        @SuppressLint("SetJavaScriptEnabled")
        fun configWebViewSetting(ctx: Context, webView: WebView) {
            webView.settings.apply {
                domStorageEnabled = true
                allowContentAccess = false
                setAppCacheEnabled(true)
                javaScriptEnabled = true
                loadWithOverviewMode = true
                setAppCachePath(appCachePath(ctx))
                useWideViewPort = true
                javaScriptCanOpenWindowsAutomatically = true
                pluginState = WebSettings.PluginState.ON
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    CookieManager.getInstance().setAcceptThirdPartyCookies(webView, true)
                    CookieManager.getInstance().setCookie("m.e-medclouds.com", "appVersion=${BuildConfig.VERSION_NAME}")
                    CookieManager.getInstance().setCookie("m-dev.e-medclouds.com", "appVersion=${BuildConfig.VERSION_NAME}")
                    mixedContentMode = WebSettings.LOAD_DEFAULT
                }
                userAgentString = String.format("$userAgentString Medclouds-doctor/${BuildConfig.VERSION_NAME}")
            }
        }


    }
}