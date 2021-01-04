/*
 * Copyright (C) 2018 贵阳货车帮科技有限公司
 */

package com.emedclouds.doctor.share.platform;

import android.app.Activity;
import android.util.Log;

import com.emedclouds.doctor.share.ShareUtils;
import com.emedclouds.doctor.share.params.ShareParams;
import com.emedclouds.doctor.share.params.WeChatParams;
import com.tencent.mm.opensdk.openapi.IWXAPI;

public class WeChatMoments extends Platform {

    private Activity mActivity;

    public WeChatMoments(Activity activity) {
        mActivity = activity;
    }

    @Override
    public void share(ShareParams shareParams) {
        if (shareParams instanceof WeChatParams) {
            IWXAPI wxapi = ShareUtils.createWXApi(mActivity);
            if (wxapi != null) {
                wxapi.sendReq(((WeChatParams) shareParams).getReq());
            } else {
                Log.e("", "WXApi is null, cancel share WeChatMoments！");
            }
        } else {
            throw new ClassCastException("ShareParams cannot be cast to WeChatParams!");
        }
    }

}
