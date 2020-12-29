@file:Suppress("DEPRECATION")

package com.emedclouds.doctor.pages

import android.app.Activity
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.Toast
import androidx.activity.ComponentActivity
import com.bumptech.glide.Glide
import com.emedclouds.doctor.R
import com.emedclouds.doctor.share.params.WeChatParams
import com.emedclouds.doctor.share.platform.WeChat
import com.emedclouds.doctor.toast.CustomToast
import com.emedclouds.doctor.utils.FileUtil
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import org.apache.commons.io.IOUtils
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream


@Suppress("DEPRECATION")
class ShareActivity : ComponentActivity() {

    companion object {
        const val PATH = "keyPath"
        const val URL = "keyUrl"
        fun openShare(activity: Activity, path: String, url: String) {
            val intent = Intent(activity, ShareActivity::class.java)
            intent.putExtra(PATH, path)
            intent.putExtra(URL, url)
            activity.startActivity(intent)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (intent == null) {
            finish()
            return
        }
        val path = intent.getStringExtra(PATH)
        val url = intent.getStringExtra(URL)
        if (path == null || url == null) {
            finish()
            return
        }
        setContentView(R.layout.activity_share_layout)
        val imageView = findViewById<ImageView>(R.id.share_pic)
        Glide.with(this)
                .load(Uri.fromFile(File(path)))
                .into(imageView)
        findViewById<LinearLayout>(R.id.share_to_wechat).setOnClickListener {
            val shareParam = WeChatParams.Builder()
                    .setImagePath(path)
                    .setScene(SendMessageToWX.Req.WXSceneSession)
                    .setShareType(WeChatParams.SHARE_IMAGE)
                    .build()
            WeChat(this@ShareActivity).share(shareParam)
            finish()
        }

        findViewById<LinearLayout>(R.id.share_to_moment).setOnClickListener {
            val shareParam = WeChatParams.Builder()
                    .setImagePath(path)
                    .setScene(SendMessageToWX.Req.WXSceneTimeline)
                    .setShareType(WeChatParams.SHARE_IMAGE)
                    .build()
            WeChat(this@ShareActivity).share(shareParam)
            finish()
        }

        findViewById<LinearLayout>(R.id.share_copylink).setOnClickListener {
            val manager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            val plainText = ClipData.newPlainText(null, url)
            manager.setPrimaryClip(plainText)
            CustomToast.show(this@ShareActivity, R.string.copy_success)
            finish()
        }

        findViewById<LinearLayout>(R.id.share_save_img).setOnClickListener {
            saveImage(path)
        }
        findViewById<View>(R.id.share_cancel).setOnClickListener {
            finish()
        }
    }

    private fun saveImage(path: String?) {
        if (path == null) {
            Toast.makeText(applicationContext, "图片下载失败", Toast.LENGTH_SHORT).show()
            return
        }
        val imageFileName = String.format("%s.jpg", System.currentTimeMillis())
        val cacheDirectory = FileUtil.getCacheDirectory(applicationContext, Environment.DIRECTORY_PICTURES)
        if (cacheDirectory == null) {
            Toast.makeText(applicationContext, "创建文件失败", Toast.LENGTH_SHORT).show()
            return
        }
        val destFile = File(cacheDirectory, imageFileName)

        var inStream: FileInputStream? = null;
        var outStream: FileOutputStream? = null
        val srcFile = File(path);
        try {
            inStream = FileInputStream(srcFile)
            outStream = FileOutputStream(destFile)
            IOUtils.copy(inStream, outStream)
            notifyGallery(destFile.absolutePath)
            CustomToast.show(this@ShareActivity, R.string.download_success)
            finish()
        } catch (e: Exception) {
            e.printStackTrace()
            return
        } finally {
            IOUtils.close(outStream)
            IOUtils.close(inStream)
        }
    }

    private fun notifyGallery(imagePath: String) {
        val mediaScanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
        val contentUri: Uri = Uri.fromFile(File(imagePath))
        mediaScanIntent.data = contentUri
        sendBroadcast(mediaScanIntent)
    }

}