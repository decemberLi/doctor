package com.emedclouds.doctor.common.web

import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN
import android.view.WindowManager.LayoutParams.FLAG_FULLSCREEN
import android.widget.FrameLayout
import androidx.activity.ComponentActivity
import androidx.annotation.LayoutRes
import androidx.annotation.NonNull
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.target.Target
import com.emedclouds.doctor.R
import com.emedclouds.doctor.common.web.api.BaseApi
import com.emedclouds.doctor.common.web.api.GalleryApi
import com.emedclouds.doctor.common.web.api.JsApiCaller
import com.emedclouds.doctor.common.web.api.NativeApiProvider
import com.emedclouds.doctor.pages.ShareActivity
import com.emedclouds.doctor.toast.CustomToast
import com.emedclouds.doctor.utils.*
import com.emedclouds.doctor.widgets.CommonInputDialog
import com.emedclouds.doctor.widgets.OnTextInputCallback
import com.emedclouds.doctor.widgets.OnTextInputCallback.Companion.ACTION_PUBLISH
import com.kaopiz.kprogresshud.KProgressHUD
import com.tencent.smtt.export.external.interfaces.*
import com.tencent.smtt.sdk.WebChromeClient
import com.tencent.smtt.sdk.WebView
import com.tencent.smtt.sdk.WebViewClient
import kotlinx.android.synthetic.main.activity_web_doctor_detail_layout.*
import kotlinx.android.synthetic.main.activity_web_layout.*
import org.json.JSONObject
import java.io.File
import java.net.URLEncoder

open class WebActivity : ComponentActivity() {

    private lateinit var mWebView: YWebView
    private lateinit var mContainer: FrameLayout

    private lateinit var mBackBtnListener: OnBackBtnListener
    private lateinit var mGalleryResultCallback: OnActivityResultCallback
    private lateinit var mPermissionCallback: OnPermissionCallback

    companion object {
        const val TAG = "YWeb.WebActivity"
        const val REQUEST_CODE_GALLERY = 1000;
    }

    @LayoutRes
    protected open fun layout(): Int {
        return R.layout.activity_web_layout
    }

    final override fun onCreate(savedInstanceState: Bundle?) {
        StatusBarUtil.setStatusBarMode(this, true, R.color.white)
        super.onCreate(savedInstanceState)
        setContentView(layout())
        hiddenTitleBar(false)
        mWebView = yWebView
        mContainer = flVideoContainer
        mWebView.webChromeClient = YWebChromeClient()
        mWebView.webViewClient = YWebViewClient()
        mWebView.setLayerType(View.LAYER_TYPE_HARDWARE, null)
        bindEvent()
        val jsApiCaller = JsApiCaller(this, mWebView)
        initJavaScriptApi(jsApiCaller)
        mWebView.addJavascriptInterface(NativeApiProvider(this, jsApiCaller), "jsCall")
        mWebView.loadUrl(getUrl())
        mEmptyView.setOnClickListener {
            mWebView.loadUrl(getUrl())
            mEmptyView.visibility = View.GONE
        }
    }

    open fun initJavaScriptApi(apiCaller: JsApiCaller) {
        ApiManager.instance.addApi("ticket",
                object : BaseApi(apiCaller) {
                    override fun doAction(bizType: String, param: String?) {
                        runOnUiThread {
                            ChannelManager.instance.callFlutter("getTicket", "", object : MethodChannelResultAdapter() {
                                override fun success(result: Any?) {
                                    successCallJavaScript(bizType, "$result")
                                    super.success(result)
                                }
                            })
                        }

                    }
                })
        ApiManager.instance.addApi("setTitle",
                object : BaseApi(apiCaller) {
                    override fun doAction(bizType: String, param: String?) {
                        populateTitleText(JSONObject(param).getString("titleText"))
                        successCallJavaScript(bizType, "OK")
                    }
                })
        ApiManager.instance.addApi("closeWindow",
                object : BaseApi(apiCaller) {
                    override fun doAction(bizType: String, param: String?) {
                        runOnUiThread { finish() }
                    }
                })
        ApiManager.instance.addApi("getWifiStatus",
                object : BaseApi(apiCaller) {
                    override fun doAction(bizType: String, param: String?) {
                        runOnUiThread {
                            ChannelManager.instance.callFlutter("wifiStatus", "", object : MethodChannelResultAdapter() {
                                override fun success(result: Any?) {
                                    if (result == null) {
                                        successCallJavaScript(bizType, false)
                                        return
                                    }
                                    successCallJavaScript(bizType, result)
                                    super.success(result)
                                }
                            })
                        }
                    }
                })
        ApiManager.instance.addApi("hookBackBtn",
                object : BaseApi(apiCaller) {
                    override fun doAction(bizType: String, param: String?) {
                        if (param == null) {
                            return
                        }
                        val json = JSONObject(param)
                        val hookBackBtn = json.getBoolean("needHook")
                        mBackBtnListener = object : OnBackBtnListener {
                            override fun onBack() {
                                successCallJavaScript(bizType, "")
                            }

                            override fun needBack(): Boolean {
                                return hookBackBtn
                            }
                        }
                    }
                })
        ApiManager.instance.addApi("showInputBar",
                object : BaseApi(apiCaller) {
                    override fun doAction(bizType: String, param: String?) {
                        if (param == null) {
                            return
                        }
                        runOnUiThread {
                            val json = JSONObject(param)
                            val id = json.optInt("id")
                            val replyContent = json.optString("replyContent") ?: ""
                            val requiredMessage = json.optString("requiredMessage") ?: "???????????????"
                            val commentContent = json.optString("commentContent") ?: ""
                            CommonInputDialog.show(this@WebActivity,
                                    json.optString("placeHolder")
                                            ?: "?????????", replyContent, commentContent, object : OnTextInputCallback {
                                override fun onInputFinish(text: String, action: String): Boolean {
                                    if (action == ACTION_PUBLISH) {
                                        if (TextUtils.isEmpty(text) || text.trim().isEmpty()) {
                                            CustomToast.toast(applicationContext, requiredMessage)
                                            return false
                                        }
                                        if (text.length > 150) {
                                            CustomToast.toast(applicationContext, "??????????????????")
                                            return false
                                        }
                                    }
                                    successCallJavaScript(bizType, JSONObject().apply {
                                        put("id", id)
                                        put("text", URLEncoder.encode(text))
                                        put("action", action)
                                    })
                                    return true
                                }
                            })
                        }
                    }
                })
        val api = GalleryApi(this, apiCaller)
        mGalleryResultCallback = api
        mPermissionCallback = api
        ApiManager.instance.addApi("openGallery", mGalleryResultCallback as GalleryApi)
        ApiManager.instance.addApi("configTitleRightBtn", object : BaseApi(apiCaller) {
            override fun doAction(bizType: String, param: String?) {
                if (TextUtils.isEmpty(param)) {
                    return
                }
                val json = JSONObject(param)
                val isShow = json.getBoolean("isShow")
                val imageUrl = json.optString("imageUrl")
                runOnUiThread {
                    iconRightBtn.apply {
                        visibility = if (isShow) {
                            setOnClickListener {
                                successCallJavaScript(bizType, "ACTION_SHARE")
                            }
                            if(!TextUtils.isEmpty(imageUrl)){
                                Glide.with(this@WebActivity).load(imageUrl)
                                        .into(iconRightBtn)
                            }
                            View.VISIBLE
                        } else {
                            View.GONE
                        }
                    }
                }
            }
        })
        ApiManager.instance.addApi("shareImage", object : BaseApi(apiCaller) {
            @SuppressLint("CheckResult")
            override fun doAction(bizType: String, param: String?) {
                if(TextUtils.isEmpty(param)){
                    return
                }
                val json = JSONObject(param)
                val imageUrl = json.getString("imgUrl")
                val url = json.getString("url")
                val jsonArray = json.getJSONArray("platform")
                val platforms =ArrayList<String>()
                for(index in 0 .. jsonArray.length()-1 step 1){
                    platforms.add(jsonArray.getString(index))
                }
                val kProgressHUD = KProgressHUD.create(this@WebActivity)
                        .setLabel("?????????...")
                        .setCancellable(false)
                        .setAnimationSpeed(2)
                        .setDimAmount(0.5f)
                        .show()
                Glide.with(applicationContext)
                        .downloadOnly()
                        .load(Uri.parse(imageUrl))
                        .listener(object : RequestListener<File> {
                            override fun onLoadFailed(e: GlideException?, model: Any?, target: Target<File>?, isFirstResource: Boolean): Boolean {
                                if(kProgressHUD.isShowing){
                                    kProgressHUD.dismiss()
                                }
                                return false
                            }

                            override fun onResourceReady(resource: File?, model: Any?, target: Target<File>?, dataSource: DataSource?, isFirstResource: Boolean): Boolean {
                                if(kProgressHUD.isShowing){
                                    kProgressHUD.dismiss()
                                }
                                if (resource == null) {
                                    return false
                                }
                                runOnUiThread {
                                    ShareActivity.openShare(this@WebActivity, resource.absolutePath, url, platforms)
                                }
                                return false
                            }
                        })
                        .preload()
            }
        })
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (this::mGalleryResultCallback.isInitialized) {
            mGalleryResultCallback.onActivityResult(requestCode, resultCode, data)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (this::mPermissionCallback.isInitialized) {
            mPermissionCallback.permissionCallback(requestCode, permissions, grantResults)
        }
    }

    @NonNull
    protected open fun getUrl(): String {
        return intent.getStringExtra("url") ?: ""
//        return "http://192.168.1.55:9000/#/questionnaire?type=market&packageStatus=EXECUTING"
    }

    private fun bindEvent() {
        btnBack.setOnClickListener {
            if (mWebView.canGoBack()) {
                mWebView.goBack()
                return@setOnClickListener
            }
            if (dispatchBackBtnIfNeeded()) {
                return@setOnClickListener
            }
            finish()
        }
    }

    fun hiddenTitleBar(hidden: Boolean) {
        mTitleContainer.visibility = if (hidden) {
            View.GONE
        } else {
            View.VISIBLE
        }
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
            // ?????????
            if (dispatchBackBtnIfNeeded()) {
                return true
            }
            if (mWebView.canGoBack()) {
                mWebView.goBack()
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun dispatchBackBtnIfNeeded(): Boolean {
        if (this::mBackBtnListener.isInitialized && mBackBtnListener.needBack()) {
            mBackBtnListener.onBack()
            return true
        }
        return false
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
            Log.i(TAG, "??????")
        } else {
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
            Log.i(TAG, "??????")
        }
    }


    inner class YWebViewClient : WebViewClient() {

        override fun onPageStarted(p0: WebView?, p1: String?, p2: Bitmap?) {
            super.onPageStarted(p0, p1, p2)
        }

        override fun onPageFinished(p0: WebView?, p1: String?) {
            super.onPageFinished(p0, p1)
        }

        // SSL ???????????????????????????????????????
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
            if ((ERROR_HOST_LOOKUP == error?.errorCode || error?.errorCode == ERROR_UNKNOWN) && request?.isForMainFrame == true) {
                mWebView.clearHistory()
                Log.d(TAG, "??????????????????")
                mEmptyView.visibility = View.VISIBLE
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

        override fun onReceivedTitle(p0: WebView?, p1: String?) {
            super.onReceivedTitle(p0, p1)
            populateTitleText(p1)
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

    private fun populateTitleText(titleText: String?) {
        if (TextUtils.isEmpty(titleText)) {
            return
        }
        Log.e(TAG, "populateTitleText: $titleText")
        tvTitle.text = titleText
    }

    interface OnBackBtnListener {
        fun onBack(): Unit

        fun needBack(): Boolean
    }

    interface OnActivityResultCallback {
        fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?)
    }

    interface OnPermissionCallback {
        fun permissionCallback(requestCode: Int, permissions: Array<out String>, grantResults: IntArray)
    }

}