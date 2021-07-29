/*
 * Copyright (C) 2018 贵阳货车帮科技有限公司
 */

package com.emedclouds.doctor.share.platform;

import com.emedclouds.doctor.share.ActionShare;

import java.util.ArrayList;

public abstract class Platform implements ActionShare {
    public static final String platformWeChat = "weChat";
    public static final String platformMoments = "Moments";
    public static final String platformClipboard = "clipboard";
    public static final String platformDownloadImage = "saveImage";

    public static final ArrayList<String> allPlatform = new ArrayList<String>() {
        {
            add(platformWeChat);
            add(platformMoments);
            add(platformClipboard);
            add(platformDownloadImage);
        }
    };
}
