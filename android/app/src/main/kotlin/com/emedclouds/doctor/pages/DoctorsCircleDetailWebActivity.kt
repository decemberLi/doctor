package com.emedclouds.doctor.pages

import android.os.Bundle
import android.os.PersistableBundle
import com.emedclouds.doctor.R
import com.emedclouds.doctor.common.web.ApiManager
import com.emedclouds.doctor.common.web.WebActivity
import com.emedclouds.doctor.common.web.api.BaseApi
import com.emedclouds.doctor.common.web.api.JsApiCaller
import com.emedclouds.doctor.widgets.CommonInputDialog
import com.emedclouds.doctor.widgets.OnTextInputCallback
import kotlinx.android.synthetic.main.activity_web_doctor_detail_layout.*
import org.json.JSONObject

class DoctorsCircleDetailWebActivity : WebActivity() {

    private var mIsLiked = true
    private var mIsFavorite = true
    private var mLikeCount = 10
    private var mCommentCount = 10

    override fun layout(): Int {
        return R.layout.activity_web_doctor_detail_layout
    }

    override fun initJavaScriptApi(apiCaller: JsApiCaller) {
        super.initJavaScriptApi(apiCaller)
    }

    override fun getUrl(): String {
        return "http://192.168.1.27:9000/#/detail?id=292"
    }


}