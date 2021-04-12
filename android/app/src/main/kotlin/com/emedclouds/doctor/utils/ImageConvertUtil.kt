package com.emedclouds.doctor.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Environment
import android.util.Base64
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.DrawableCompat
import org.apache.commons.io.IOUtils
import java.io.File
import java.io.FileOutputStream

class ImageConvertUtil {

    companion object{
        fun getBitmapFromVectorDrawable(context: Context?, drawableId: Int): Bitmap? {
            var drawable = ContextCompat.getDrawable(context!!, drawableId)
            val bitmap = Bitmap.createBitmap(drawable!!.intrinsicWidth, drawable.intrinsicHeight,
                    Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            return bitmap
        }

        fun BitmapToDrawable(bitmap: Bitmap?, context: Context): Drawable? {
            return BitmapDrawable(context.resources, bitmap)
        }

        /**
         * base64转为bitmap
         *
         * @param base64Data
         * @return
         */
        fun base64ToBitmap(base64Data: String?): Bitmap? {
            val bytes = Base64.decode(base64Data, Base64.NO_WRAP)
            return BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
        }


        fun base64ToFile(context: Context, base64Data: String?, imageFileName: String): File? {
            if (base64Data == null) {
                return null
            }
            val bytes = Base64.decode(base64Data, Base64.NO_WRAP)
            val cacheDirectory = FileUtil.getCacheDirectory(context, Environment.DIRECTORY_PICTURES)
            val imageFile = File(cacheDirectory, imageFileName)
            IOUtils.write(bytes, FileOutputStream(imageFile))
            return imageFile;
        }
    }
}