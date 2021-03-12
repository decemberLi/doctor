package com.emedclouds.doctor.utils;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.leon.channel.helper.ChannelReaderUtil;

public class PackerNg {
    private static final String TAG = "PackerNg";
    private static final String EMPTY_STRING = "official";

    private PackerNg() {
        throw new AssertionError("Don't instance! ");
    }

    @NonNull
    public static String getChannel(@NonNull Context context) {
        return getChannel(context, EMPTY_STRING);
    }

    /**
     * 获取渠道号
     *
     * @param context      Context
     * @param defaultValue 默认渠道号
     * @return 渠道号
     */
    @NonNull
    public static String getChannel(@NonNull Context context, @NonNull String defaultValue) {
        final String channel = ChannelReaderUtil.getChannel(context.getApplicationContext());
        Log.i(TAG, "getChannel: " + channel);
        return channel != null ? channel : defaultValue;
    }
}