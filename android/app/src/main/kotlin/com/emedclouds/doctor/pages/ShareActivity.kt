@file:Suppress("DEPRECATION")

package com.emedclouds.doctor.pages

import android.app.Activity
import android.content.*
import android.content.pm.PackageManager
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.Toast
import androidx.activity.ComponentActivity
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.emedclouds.doctor.R
import com.emedclouds.doctor.share.params.WeChatParams
import com.emedclouds.doctor.share.platform.Platform
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
        const val tag = "ShareActivity"
        const val PATH = "keyPath"
        const val URL = "keyUrl"
        const val PLATFORMS = "platforms"

        fun openShare(activity: Activity, path: String, url: String, platforms: ArrayList<String>) {
            val intent = Intent(activity, ShareActivity::class.java)
            intent.putExtra(PATH, path)
            intent.putExtra(URL, url)
            intent.putStringArrayListExtra(PLATFORMS, platforms)
            activity.startActivity(intent)
        }
    }

    lateinit var path: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (intent == null) {
            finish()
            return
        }
        path = intent.getStringExtra(PATH)!!
        val url = intent.getStringExtra(URL)
        if (url == null) {
            finish()
            return
        }
        setContentView(R.layout.activity_share_layout)
        val imageView = findViewById<ImageView>(R.id.share_pic)
        val platforms: ArrayList<String> = intent.getSerializableExtra(PLATFORMS) as ArrayList<String>
        Glide.with(this)
                .load(Uri.fromFile(File(path)))
                .skipMemoryCache(false)
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .into(imageView)
        findViewById<LinearLayout>(R.id.share_to_wechat).apply {
            visibility = if (platforms.contains(Platform.platformWeChat)) {
                setOnClickListener {
                    val shareParam = WeChatParams.Builder()
                            .setImagePath(path)
                            .setScene(SendMessageToWX.Req.WXSceneSession)
                            .setShareType(WeChatParams.SHARE_IMAGE)
                            .build()
                    WeChat(this@ShareActivity).share(shareParam)
                    finish()
                }
                View.VISIBLE
            } else {
                View.GONE
            }

        }

        findViewById<LinearLayout>(R.id.share_to_moment).apply {
            visibility = if (platforms.contains(Platform.platformMoments)) {
                setOnClickListener {
                    val shareParam = WeChatParams.Builder()
                            .setImagePath(path)
                            .setScene(SendMessageToWX.Req.WXSceneTimeline)
                            .setShareType(WeChatParams.SHARE_IMAGE)
                            .build()
                    WeChat(this@ShareActivity).share(shareParam)
                    finish()
                }
                View.VISIBLE
            } else {
                View.GONE
            } 
        }

        findViewById<LinearLayout>(R.id.share_copylink).apply {
            visibility = if (platforms.contains(Platform.platformClipboard)) {
                setOnClickListener {
                    val manager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                    val plainText = ClipData.newPlainText(null, url)
                    manager.setPrimaryClip(plainText)
                    CustomToast.show(this@ShareActivity, R.string.copy_success)
                }
                View.VISIBLE
            } else {
                View.GONE
            }

        }

        findViewById<LinearLayout>(R.id.share_save_img).apply {
            visibility = if (platforms.contains(Platform.platformDownloadImage)) {
                setOnClickListener {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        requestPermissions(arrayOf(
                                "android.permission.READ_EXTERNAL_STORAGE",
                                "android.permission.WRITE_EXTERNAL_STORAGE"
                        ), 10)
                    } else {
                        saveImage(path)
                    }
                }
                View.VISIBLE
            } else {
                View.GONE
            }
        }
        findViewById<View>(R.id.share_cancel).setOnClickListener {
            finish()
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (grantResults.isNotEmpty()) {
            grantResults.forEach {
                if (it != PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this@ShareActivity, "权限拒绝", Toast.LENGTH_SHORT).show()
                    return
                }
            }
            saveImage(path)
        }
    }

    private fun saveImage(path: String?) {
        if (path == null) {
            Toast.makeText(applicationContext, "图片下载失败", Toast.LENGTH_SHORT).show()
            return
        }
        val imageFileName = String.format("%s.png", System.currentTimeMillis())
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
        } catch (e: Exception) {
            e.printStackTrace()
            return
        } finally {
            IOUtils.close(outStream)
            IOUtils.close(inStream)
        }
    }

    private fun notifyGallery(imagePath: String) {
        val file = File(imagePath)
        MediaStore.Images.Media.insertImage(this.contentResolver, file.absolutePath, file.name, null)
        MediaScannerConnection.scanFile(this, arrayOf(imagePath), null,
                object : MediaScannerConnection.OnScanCompletedListener {
                    override fun onScanCompleted(path: String?, uri: Uri?) {
                        Log.w(tag, "path -> $path; uri -> $uri")
                    }

                })
    }

}