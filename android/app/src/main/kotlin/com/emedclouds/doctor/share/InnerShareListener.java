/*
 * Copyright (C) 2018 贵阳货车帮科技有限公司
 */

package com.emedclouds.doctor.share;

import com.emedclouds.doctor.share.platform.Platform;

public interface InnerShareListener {
    void onComplete(Platform platform);

    void onError(Platform platform, Throwable throwable);

    void onCancel(Platform platform);
}
