/*
 * Copyright (C) 2018 贵阳货车帮科技有限公司
 */

package com.emedclouds.doctor.share;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;

import com.emedclouds.doctor.R;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;


public class ShareUtils {

    private static final String TAG = "tencent";

    public static IWXAPI createWXApi(Activity activity) {
        if (activity == null) {
            Log.e(TAG, "Activity is null, cancel create WXApi！");
            return null;
        }
        String weChatAppId = activity.getString(R.string.wx_app_id);
        if (TextUtils.isEmpty(weChatAppId)) {
            Log.e(TAG, "wx_app_id 没有正确配置！");
            return null;
        }
        return WXAPIFactory.createWXAPI(activity.getApplicationContext(), weChatAppId);
    }

    private static Handler sMainHandler;
    private static final Object sMainHandlerLock = new Object();

    public static Handler getMainHandler() {
        if (sMainHandler == null) {
            synchronized (sMainHandlerLock) {
                if (sMainHandler == null) {
                    sMainHandler = new Handler(Looper.getMainLooper());
                }
            }
        }
        return sMainHandler;
    }

}
