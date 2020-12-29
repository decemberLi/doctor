package com.emedclouds.doctor.wxapi

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.ComponentActivity
import com.emedclouds.doctor.MainActivity
import com.emedclouds.doctor.R
import com.emedclouds.doctor.common.constants.keyLaunchParam
import com.emedclouds.doctor.share.InnerShareListener
import com.emedclouds.doctor.share.ShareManager
import com.emedclouds.doctor.share.ShareUtils
import com.emedclouds.doctor.toast.CustomToast
import com.tencent.mm.opensdk.constants.ConstantsAPI
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelmsg.ShowMessageFromWX
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler


class WXEntryActivity : ComponentActivity(), IWXAPIEventHandler {
    private val tag = "WXHandlerActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val wxapi = ShareUtils.createWXApi(this)
        wxapi?.handleIntent(intent, this)
        finish()
    }

    override fun onReq(req: BaseReq?) {
        val intent = Intent(this@WXEntryActivity, MainActivity::class.java)
        if (req?.type == ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX && req is ShowMessageFromWX.Req) {
            val showReq = req as ShowMessageFromWX.Req
            val mediaMsg = showReq.message
            val extInfo = mediaMsg.messageExt
            Log.d(tag, String.format("extInfo ===> %s", extInfo))
            Log.d(tag, String.format("message ===> %s", mediaMsg))
            Log.d(tag, "message ===> $mediaMsg")
            if (extInfo != null) {
                intent.putExtra(keyLaunchParam, extInfo);
            }
        }
        startActivity(Intent(intent))
        finish()
    }

    override fun onResp(resp: BaseResp?) {
        Log.d(tag, "onResp errStr: ${resp?.errStr} onResp transaction: ${resp?.transaction}")
        if (resp == null) {
            return
        }
        when (resp.errCode) {
            BaseResp.ErrCode.ERR_OK -> {
                Log.d(tag, "ERR_OK")
                CustomToast.show(this@WXEntryActivity, R.string.share_success)
            }
            BaseResp.ErrCode.ERR_USER_CANCEL -> {
                // 取消（微信现在已不再返回取消，取消一律按ok返回）
                Log.d(tag, "ERR_USER_CANCEL")
//                Toast.makeText(this@WXEntryActivity, "分享已取消", Toast.LENGTH_SHORT).show()
            }
//            BaseResp.ErrCode.ERR_AUTH_DENIED -> {
//                // 认证被否决
//            }
//            BaseResp.ErrCode.ERR_SENT_FAILED -> {
//                // 发送失败
//            }
//            BaseResp.ErrCode.ERR_UNSUPPORT -> {
//                // 不支持的错误
//            }
//            BaseResp.ErrCode.ERR_COMM -> {
//                // 一般错误
//            }
            else -> {
//                Toast.makeText(this@WXEntryActivity, "分享失败", Toast.LENGTH_SHORT).show()
                Log.d(tag, "errCode: ${resp.errCode}")
            }
        }
    }
}