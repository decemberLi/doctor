package com.emedclouds.doctor.common.gallery

import android.content.Context
import com.zhihu.matisse.MimeType
import com.zhihu.matisse.filter.Filter
import com.zhihu.matisse.internal.entity.IncapableCause
import com.zhihu.matisse.internal.entity.Item

class ImageFilter : Filter() {
    override fun constraintTypes(): MutableSet<MimeType> {
        return HashSet<MimeType>().apply {
            add(MimeType.PNG)
            add(MimeType.JPEG)
            add(MimeType.BMP)
            add(MimeType.WEBP)
        }
    }

    override fun filter(context: Context?, item: Item?): IncapableCause? {
        return null
    }
}