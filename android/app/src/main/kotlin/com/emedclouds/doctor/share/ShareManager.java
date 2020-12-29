/*
 * Copyright (C) 2018 - 2019 贵阳货车帮科技有限公司
 */

package com.emedclouds.doctor.share;

import android.app.Activity;

import java.lang.ref.WeakReference;

public class ShareManager {

    private ShareManager() {
    }

    public static ShareManager getInstance() {
        return Holder.INSTANCE;
    }

    private static class Holder {
        private static final ShareManager INSTANCE = new ShareManager();
    }

    private String mQQAppId;
    private String mWechatAppId;

    private WeakReference<InnerShareListener> mListener;

    public void setQQAppId(String qqAppId) {
        mQQAppId = qqAppId;
    }

    public String getQQAppId() {
        return mQQAppId;
    }

    public void setWechatAppId(String wechatAppId) {
        mWechatAppId = wechatAppId;
    }

    public String getWechatAppId() {
        return mWechatAppId;
    }

    public void setInnerShareListener(InnerShareListener listener) {
        mListener = new WeakReference<>(listener);
    }

    public InnerShareListener getInnerShareListener() {
        return mListener.get();
    }

}
