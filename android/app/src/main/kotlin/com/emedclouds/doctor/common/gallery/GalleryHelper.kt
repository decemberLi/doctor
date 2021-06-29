package com.emedclouds.doctor.common.gallery

import android.app.Activity
import android.content.pm.ActivityInfo
import com.emedclouds.doctor.BuildConfig
import com.emedclouds.doctor.R
import com.zhihu.matisse.Matisse
import com.zhihu.matisse.MimeType
import com.zhihu.matisse.internal.entity.CaptureStrategy
import javax.annotation.Nonnull

class GalleryHelper {

    companion object {

        const val REQUEST_CODE_GALLERY_DEFAULT = 0x00000111

        fun openGallery(@Nonnull activity: Activity,
                        requestCode: Int = REQUEST_CODE_GALLERY_DEFAULT,
                        maxSelectable: Int = 1,
                        captureEnable: Boolean = true) {
            Matisse.from(activity)
                    .choose(HashSet<MimeType>().apply {
                        add(MimeType.PNG)
                        add(MimeType.JPEG)
                        add(MimeType.BMP)
                        add(MimeType.WEBP)
                    }, true)
                    .showSingleMediaType(true)
                    .countable(maxSelectable == 1)
                    .capture(captureEnable)
                    .captureStrategy(CaptureStrategy(false, BuildConfig.APPLICATION_ID))
                    .maxSelectable(maxSelectable)
                    .restrictOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
                    .thumbnailScale(0.85f)
                    .addFilter(ImageFilter())
                    .imageEngine(DemoImageEngine())
                    .theme(R.style.Matisse_Dracula)
                    .forResult(requestCode)
        }

    }

}