package com.emedclouds.doctor.common.web.api

import android.content.Intent
import android.widget.Toast
import androidx.activity.ComponentActivity
import com.emedclouds.doctor.common.gallery.GalleryHelper
import com.emedclouds.doctor.common.web.WebActivity
import com.emedclouds.doctor.utils.*
import com.google.gson.Gson
import com.kaopiz.kprogresshud.KProgressHUD
import com.zhihu.matisse.Matisse
import org.json.JSONArray
import org.json.JSONObject

interface Callback<T> {
    fun success(param: T)

    fun error(errorCode: Int, errorMsg: String)
}

class GalleryApi(val activity: WebActivity,
                 mApiCaller: JsApiCaller) : BaseApi(mApiCaller), WebActivity.OnActivityResultCallback, WebActivity.OnPermissionCallback {

    private lateinit var mBizType: String
    private lateinit var mCallback: Callback<String>

    private var mMaxCount: Int = 1
    private var mCaptureAble: Boolean = true

    override fun doAction(bizType: String, param: String?) {
        if (param == null) {
            return
        }

        val json = JSONObject(param)
        mMaxCount = json.optInt("maxCount", 1)
        mCaptureAble = json.optBoolean("enableCapture", true)
        mBizType = bizType;
        if (mMaxCount > 9) {
            errorCallJavaScript(bizType, -2, "参数错误")
            return
        }
        activity.runOnUiThread {
            if (mCaptureAble && (!checkCameraPermission(activity))) {
                requestCameraPermission(activity, REQUEST_CODE_CAMERA_PERMISSION)
            }
            if (checkExternalPermission(activity)) {
                openGallery()
            } else {
                requestExternalStoragePermission(activity, REQUEST_CODE_EXTERNAL_STORAGE_PERMISSION)
            }
            mCallback = object : Callback<String> {
                override fun success(param: String) {
                    successCallJavaScript(bizType, JSONArray(param))
                }

                override fun error(errorCode: Int, errorMsg: String) {
                    errorCallJavaScript(bizType, errorCode, errorMsg)
                }
            }
        }
    }

    private fun openGallery() {
        GalleryHelper.openGallery(
                activity,
                maxSelectable = mMaxCount,
                captureEnable = mCaptureAble,
                requestCode = WebActivity.REQUEST_CODE_GALLERY
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == WebActivity.REQUEST_CODE_GALLERY && data != null) {
            doUploadImage(data, resultCode)
        }
    }

    private fun doUploadImage(data: Intent?, resultCode: Int) {
        if (!this::mCallback.isInitialized) {
            return
        }
        val list = Matisse.obtainPathResult(data)
        if (ComponentActivity.RESULT_OK != resultCode || data == null) {
            mCallback.error(-1, "图片选择异常")
            return
        }
        if (list != null && list.size != 0) {
            val kProgressHUD = KProgressHUD.create(activity)
                    .setLabel("图片上传中...")
                    .setCancellable(false)
                    .setAnimationSpeed(2)
                    .setDimAmount(0.5f)
                    .show()
            ChannelManager.instance.callFlutter("uploadFile", Gson().toJson(list), object : MethodChannelResultAdapter() {
                override fun success(result: Any?) {
                    kProgressHUD.dismiss()
                    if (result != null && result is String) {
                        mCallback.success(result)
                    }
                }

                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                    kProgressHUD.dismiss()
                    mCallback.error(-1, errorMessage ?: "接口错误")
                }
            })
        }
    }

    override fun permissionCallback(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_CODE_CAMERA_PERMISSION) {
            if (mCaptureAble && checkCameraPermission(activity)) {
                openGallery()
            } else {
                Toast.makeText(activity, " 缺少相机权限 ", Toast.LENGTH_SHORT).show()
            }
        } else if (requestCode == REQUEST_CODE_EXTERNAL_STORAGE_PERMISSION) {
            if (mCaptureAble && checkExternalPermission(activity)) {
                openGallery()
            } else {
                Toast.makeText(activity, " 缺少相册权限 ", Toast.LENGTH_SHORT).show()
            }
        }
    }

}