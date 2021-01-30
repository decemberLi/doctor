package com.emedclouds.doctor.common.web

import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.graphics.Bitmap
import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN
import android.view.WindowManager.LayoutParams.FLAG_FULLSCREEN
import android.widget.FrameLayout
import android.widget.TextView
import androidx.activity.ComponentActivity
import com.emedclouds.doctor.R
import com.emedclouds.doctor.utils.StatusBarUtil
import com.kaopiz.kprogresshud.KProgressHUD
import com.tencent.smtt.export.external.interfaces.*
import com.tencent.smtt.sdk.WebChromeClient
import com.tencent.smtt.sdk.WebView
import com.tencent.smtt.sdk.WebViewClient
import kotlinx.android.synthetic.main.activity_web_layout.*

class WebActivity : ComponentActivity() {

    private lateinit var mWebView: WebView
    private lateinit var mContainer: FrameLayout

    companion object {
        const val TAG = "YWebActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        StatusBarUtil.setStatusBarMode(this, true, R.color.tt_33ffffff)
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_web_layout)
        mTitleContainer.visibility = View.GONE
        mWebView = yWebView
        mContainer = flVideoContainer
        mWebView.webChromeClient = YWebChromeClient()
        mWebView.webViewClient = YWebViewClient()
        mWebView.loadUrl("http://www.baidu.com")
    }

    override fun onPause() {
        mWebView.onPause()
        super.onPause()
    }

    override fun onResume() {
        super.onResume()
        mWebView.onResume()
    }

    override fun onDestroy() {
        mWebView.destroy()
        super.onDestroy()
    }


    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (mWebView.canGoBack()) {
                mWebView.goBack()
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        when (newConfig.orientation) {
            Configuration.ORIENTATION_LANDSCAPE -> {
                window.clearFlags(FLAG_FORCE_NOT_FULLSCREEN)
                window.addFlags(FLAG_FULLSCREEN)
            }
            Configuration.ORIENTATION_PORTRAIT -> {
                window.clearFlags(FLAG_FULLSCREEN)
                window.addFlags(FLAG_FORCE_NOT_FULLSCREEN)
            }
        }
    }

    fun fullScreen() {
        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
            Log.i(TAG, "横屏")
        } else {
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
            Log.i(TAG, "竖屏")
        }
    }


    inner class YWebViewClient : WebViewClient() {
        val mKProgressHUD = KProgressHUD(this@WebActivity)
                .setLabel("加载中...")

        override fun onPageStarted(p0: WebView?, p1: String?, p2: Bitmap?) {
            mKProgressHUD.show()
            super.onPageStarted(p0, p1, p2)
        }

        override fun onPageFinished(p0: WebView?, p1: String?) {
            mKProgressHUD.dismiss()
            super.onPageFinished(p0, p1)
        }

        // SSL 握手错误，本次请求一定失败
        override fun onReceivedSslError(view: WebView?,
                                        handler: SslErrorHandler?,
                                        error: SslError?) {
            super.onReceivedSslError(view, handler, error)
        }

        override fun onReceivedError(view: WebView?,
                                     errorCode: Int,
                                     description: String?,
                                     failingUrl: String?) {
            super.onReceivedError(view, errorCode, description, failingUrl)

        }

        override fun onReceivedError(view: WebView?,
                                     request: WebResourceRequest?,
                                     error: WebResourceError?) {
            if (ERROR_HOST_LOOKUP == error?.errorCode) {
                Log.d(TAG, "网络链接错误")
            } else {
                Log.d(TAG,
                        "onReceivedError:: errorCode [${error?.errorCode}], errorMsg [${error?.description}]")
            }
        }

        override fun onReceivedHttpError(view: WebView?,
                                         request: WebResourceRequest?,
                                         errorResponse: WebResourceResponse?) {
            super.onReceivedHttpError(view, request, errorResponse)
        }

        override fun shouldOverrideUrlLoading(p0: WebView?, p1: String?): Boolean {
            if (p1 != null) {
                if (!p1.startsWith("http") && !p1.startsWith("https")) {
                    Log.d(TAG, "Scheme not support.")
                    return true
                }
            }
            Log.d(TAG, "shouldOverrideUrlLoading: $p1 ")
            return super.shouldOverrideUrlLoading(p0, p1)
        }

        override fun onLoadResource(p0: WebView?, p1: String?) {
            Log.d(TAG, "On load resources, url -< [$p1]")
            super.onLoadResource(p0, p1)
        }
    }

    inner class YWebChromeClient : WebChromeClient() {
        private var mCallback: IX5WebChromeClient.CustomViewCallback? = null
        override fun onCloseWindow(p0: WebView?) {
            super.onCloseWindow(p0)
        }

        override fun onProgressChanged(p0: WebView?, p1: Int) {
            Log.d(TAG, "onProgressChanged: $p1")
            super.onProgressChanged(p0, p1)
        }

        override fun onShowCustomView(p0: View?, p1: IX5WebChromeClient.CustomViewCallback?) {
            fullScreen()
            mWebView.visibility = View.GONE
            mContainer.visibility = View.VISIBLE
            mContainer.addView(p0)
            Log.d(TAG, "onShowCustomView: ")
            this.mCallback = p1
            super.onShowCustomView(p0, p1)
        }

        override fun getVideoLoadingProgressView(): View {
            return TextView(this@WebActivity).apply {
                text = "------..."
            }
        }

        override fun onHideCustomView() {
            fullScreen()
            mWebView.visibility = View.VISIBLE
            mContainer.visibility = View.GONE
            mContainer.removeAllViews()
            mCallback?.onCustomViewHidden()
            Log.d(TAG, "onHideCustomView: ")
            super.onHideCustomView()
        }

    }

}