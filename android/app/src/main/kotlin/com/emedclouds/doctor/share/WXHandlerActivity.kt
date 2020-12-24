package com.emedclouds.doctor.share

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler

class WXHandlerActivity : ComponentActivity(), IWXAPIEventHandler {
    private val tag = "WXHandlerActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val wxapi = ShareUtils.createWXApi(this)
        wxapi?.handleIntent(intent, this)
        finish()
    }

    override fun onReq(resp: BaseReq?) {
        // Do nothing
    }

    override fun onResp(resp: BaseResp?) {
        Log.d(tag, "onResp errStr: ${resp?.errStr} onResp transaction: ${resp?.transaction}")
        if (resp == null) {
            return
        }
        val listener: InnerShareListener = ShareManager.getInstance().innerShareListener;
        listener.onComplete(null)
        when (resp.errCode) {
            BaseResp.ErrCode.ERR_OK -> {
                Log.d(tag, "ERR_OK")
                listener.onComplete(null)
            }
            BaseResp.ErrCode.ERR_USER_CANCEL -> {
                // 取消（微信现在已不再返回取消，取消一律按ok返回）
                Log.d(tag, "ERR_USER_CANCEL")
                listener.onCancel(null)
            }
            BaseResp.ErrCode.ERR_AUTH_DENIED -> {
                // 认证被否决
            }
            BaseResp.ErrCode.ERR_SENT_FAILED -> {
                // 发送失败
            }
            BaseResp.ErrCode.ERR_UNSUPPORT -> {
                // 不支持的错误
            }
            BaseResp.ErrCode.ERR_COMM -> {
                // 一般错误
            }
            else -> {
                Log.d(tag, "errCode: ${resp.errCode}")
                listener.onError(null, Throwable(resp.errStr))
            }
        }
    }
}