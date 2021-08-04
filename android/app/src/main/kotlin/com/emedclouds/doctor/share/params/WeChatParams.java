/*
 * Copyright (C) 2018 贵阳货车帮科技有限公司
 */

package com.emedclouds.doctor.share.params;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.IntDef;
import androidx.annotation.NonNull;

import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXImageObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXMiniProgramObject;
import com.tencent.mm.opensdk.modelmsg.WXMusicObject;
import com.tencent.mm.opensdk.modelmsg.WXTextObject;
import com.tencent.mm.opensdk.modelmsg.WXVideoObject;
import com.tencent.mm.opensdk.modelmsg.WXWebpageObject;

import org.apache.commons.io.IOUtils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public class WeChatParams extends ShareParams {

    public static final int SHARE_TEXT = 1;
    public static final int SHARE_IMAGE = 2;
    public static final int SHARE_MUSIC = 3;
    public static final int SHARE_VIDEO = 4;
    public static final int SHARE_WEB_PAGE = 5;
    public static final int SHARE_MINI_PROGRAM = 6;

    /**
     * 微信的分享，无论是朋友圈还是收藏还是好友，都共用这一个参数类，由scene决定分享的场景
     */
    @IntDef({
            SendMessageToWX.Req.WXSceneSession,             // 微信会话
            SendMessageToWX.Req.WXSceneTimeline,            // 朋友圈
            // SendMessageToWX.Req.WXSceneFavorite,         // 收藏
            // SendMessageToWX.Req.WXSceneSpecifiedContact  // 指定联系人
    })
    @Retention(RetentionPolicy.SOURCE)
    public @interface SceneType {
    }

    @IntDef({
            SHARE_TEXT,         // 分享文本
            SHARE_IMAGE,        // 分享图片
            SHARE_MUSIC,        // 分享音乐
            SHARE_VIDEO,        // 分享视频
            SHARE_WEB_PAGE,      // 分享网页
            SHARE_MINI_PROGRAM   // 分享小程序
    })
    @Retention(RetentionPolicy.SOURCE)
    public @interface ShareType {
    }

    private SendMessageToWX.Req mReq;

    public SendMessageToWX.Req getReq() {
        return mReq;
    }


    public WeChatParams(@NonNull Builder builder) {
        switch (builder.mShareType) {
            case SHARE_TEXT:
                mReq = buildTextReq(builder);
                break;
            case SHARE_IMAGE:
                mReq = buildImageReq(builder);
                break;
            case SHARE_MUSIC:
                mReq = buildMusicReq(builder);
                break;
            case SHARE_VIDEO:
                mReq = buildVideoReq(builder);
                break;
            case SHARE_WEB_PAGE:
                mReq = buildWebPageReq(builder);
                break;
            case SHARE_MINI_PROGRAM:
                mReq = buildMiniProgramReq(builder);
                break;
        }
    }


    private SendMessageToWX.Req buildTextReq(@NonNull Builder builder) {
        WXTextObject textObj = new WXTextObject();
        textObj.text = builder.mText;

        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = textObj;
        msg.description = builder.mDescription;

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = toTransaction("text");
        req.message = msg;
        req.scene = builder.mScene;
        return req;
    }

    private SendMessageToWX.Req buildImageReq(@NonNull Builder builder) {
        Bitmap bitmap = getBitmap(builder);
        WXImageObject imgObj = new WXImageObject(bitmap);
        File file = new File(builder.mImagePath);
        byte[] bytes = new byte[(int)file.length()];
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(file);
            fis.read(bytes);
            imgObj.imageData = bytes;
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            IOUtils.closeQuietly(fis);
        }

        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = imgObj;
        msg.thumbData = toThumbData(bitmap, 1 << 15);

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = toTransaction("image");
        req.message = msg;
        req.scene = builder.mScene;
        return req;
    }

    private SendMessageToWX.Req buildMusicReq(@NonNull Builder builder) {
        WXMusicObject musicObj = new WXMusicObject();
        musicObj.musicUrl = builder.mUrl;

        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = musicObj;
        msg.title = builder.mTitle;
        msg.description = builder.mDescription;
        msg.thumbData = toThumbData(getBitmap(builder), 1 << 15);

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = toTransaction("music");
        req.message = msg;
        req.scene = builder.mScene;
        return req;
    }

    private SendMessageToWX.Req buildVideoReq(@NonNull Builder builder) {
        WXVideoObject videoObj = new WXVideoObject();
        videoObj.videoUrl = builder.mUrl;

        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = videoObj;
        msg.title = builder.mTitle;
        msg.description = builder.mDescription;
        msg.thumbData = toThumbData(getBitmap(builder), 1 << 15);

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = toTransaction("video");
        req.message = msg;
        req.scene = builder.mScene;
        return req;
    }

    private SendMessageToWX.Req buildWebPageReq(@NonNull Builder builder) {
        WXWebpageObject webpageObj = new WXWebpageObject();
        webpageObj.webpageUrl = builder.mUrl;

        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = webpageObj;
        msg.title = builder.mTitle;
        msg.description = builder.mDescription;
        msg.thumbData = toThumbData(getBitmap(builder), 1 << 15);

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = toTransaction("webpage");
        req.message = msg;
        req.scene = builder.mScene;
        return req;
    }

    private SendMessageToWX.Req buildMiniProgramReq(@NonNull Builder builder) {
        WXMiniProgramObject miniProgramObj = new WXMiniProgramObject();
        miniProgramObj.webpageUrl = builder.mUrl;
        miniProgramObj.miniprogramType = WXMiniProgramObject.MINIPTOGRAM_TYPE_RELEASE;
        miniProgramObj.userName = builder.mUsername;
        miniProgramObj.path = builder.mPath;

        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = miniProgramObj;
        msg.title = builder.mTitle;
        msg.description = builder.mDescription;
        msg.thumbData = toThumbData(getBitmap(builder), 1 << 17);

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = toTransaction("miniprogram");
        req.message = msg;
        req.scene = builder.mScene;
        return req;
    }

    /**
     * 构造唯一标识一个请求的transaction字段
     */
    @NonNull
    private String toTransaction(final String type) {
        return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
    }

    private Bitmap getBitmap(Builder builder) {
        if (builder.mBitmap != null) {
            return builder.mBitmap;
        } else if (!TextUtils.isEmpty(builder.mImagePath)) {
            return BitmapFactory.decodeFile(builder.mImagePath);
        } else if (!TextUtils.isEmpty(builder.mImageUrl)) {
            // This should not happen.
        } else {
            Log.e("WeChatParams", "ImageData & ImagePath & ImageUrl 至少必须设置一个!");
        }
        return null;
    }

    /**
     * 微信分享 普通缩略图大小不能超过32k,小程序封面缩略图大小不能超过128k.
     */
    private byte[] toThumbData(@NonNull Bitmap bitmap, final int upper) {
        if (bitmap == null) {
            return null;
        }
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        int size = bitmap.getByteCount();
        int scaleExp = calculateScaleExp(size, upper);
        Bitmap scaledBmp = Bitmap.createScaledBitmap(bitmap, width >> scaleExp, height >> scaleExp, true);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        scaledBmp.compress(Bitmap.CompressFormat.JPEG, 100, baos);
        return baos.toByteArray();
    }

    private int calculateScaleExp(int size, final int upper) {
        int exp = 0;
        for (int scale = size / upper; scale > 0; exp++) {
            scale >>= 1;
        }
        return (exp + 1) >> 1;
    }


    public static class Builder {
        protected @SceneType
        int mScene;
        protected @ShareType
        int mShareType;
        protected String mText;
        protected Bitmap mBitmap;
        protected String mImageUrl;
        protected String mImagePath;
        protected String mUrl;
        protected String mTitle;
        protected String mDescription;
        protected String mUsername;
        protected String mPath;  // 小程序path

        public Builder() {
            setScene(SendMessageToWX.Req.WXSceneSession);
        }

        public Builder setScene(@SceneType int scene) {
            this.mScene = scene;
            return this;
        }

        public Builder setShareType(@ShareType int shareType) {
            this.mShareType = shareType;
            return this;
        }

        public Builder setText(String text) {
            this.mText = text;
            return this;
        }

        public Builder setBitmap(Bitmap bitmap) {
            this.mBitmap = bitmap;
            return this;
        }

        public Builder setImageUrl(String imageUrl) {
            this.mImageUrl = imageUrl;
            return this;
        }

        public Builder setImagePath(String imagePath) {
            this.mImagePath = imagePath;
            return this;
        }

        public Builder setUrl(String url) {
            this.mUrl = url;
            return this;
        }

        public Builder setTitle(String title) {
            this.mTitle = title;
            return this;
        }

        public Builder setDescription(String description) {
            this.mDescription = description;
            return this;
        }

        public Builder setUsername(String username) {
            this.mUsername = username;
            return this;
        }

        public Builder setPath(String path) {
            this.mPath = path;
            return this;
        }

        public WeChatParams build() {
            return new WeChatParams(this);
        }
    }

}