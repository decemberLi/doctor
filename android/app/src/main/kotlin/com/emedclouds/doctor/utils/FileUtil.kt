package com.emedclouds.doctor.utils

import android.content.Context
import android.os.Environment
import android.text.TextUtils
import android.util.Log
import java.io.Closeable
import java.io.File
import java.lang.Exception

@Suppress("DEPRECATION")
class FileUtil {

    companion object {
        private const val tag = "FileUtil"

        /**
         * 获取SD卡缓存目录
         * @param context 上下文
         * @param type 文件夹类型 如果为空则返回 /storage/emulated/0/Android/data/app_package_name/cache
         * 否则返回对应类型的文件夹如Environment.DIRECTORY_PICTURES 对应的文件夹为 .../data/app_package_name/files/Pictures
         * [android.os.Environment.DIRECTORY_MUSIC],
         * [android.os.Environment.DIRECTORY_PODCASTS],
         * [android.os.Environment.DIRECTORY_RINGTONES],
         * [android.os.Environment.DIRECTORY_ALARMS],
         * [android.os.Environment.DIRECTORY_NOTIFICATIONS],
         * [android.os.Environment.DIRECTORY_PICTURES], or
         * [android.os.Environment.DIRECTORY_MOVIES].or 自定义文件夹名称
         * @return 缓存目录文件夹 或 null（无SD卡或SD卡挂载失败）
         */
        private fun getExternalCacheDirectory(context: Context, type: String): File? {
            var appCacheDir: File? = null
            if (Environment.MEDIA_MOUNTED == Environment.getExternalStorageState()) {
                appCacheDir = if (TextUtils.isEmpty(type)) {
                    context.externalCacheDir
                } else {
                    context.getExternalFilesDir(type)
                }
                if (appCacheDir == null) { // 有些手机需要通过自定义目录
                    appCacheDir = File(Environment.getExternalStorageDirectory(), "Android/data/" + context.packageName.toString() + "/cache/" + type)
                }
                if (!appCacheDir.exists() && !appCacheDir.mkdirs()) {
                    Log.e("getExternalDirectory", "getExternalDirectory fail ,the reason is make directory fail !")
                }
            } else {
                Log.e("getExternalDirectory", "getExternalDirectory fail ,the reason is sdCard nonexistence or sdCard mount fail !")
            }
            return appCacheDir
        }

        /**
         * 获取应用专属缓存目录
         * android 4.4及以上系统不需要申请SD卡读写权限
         * 因此也不用考虑6.0系统动态申请SD卡读写权限问题，切随应用被卸载后自动清空 不会污染用户存储空间
         * @param context 上下文
         * @param type 文件夹类型 可以为空，为空则返回API得到的一级目录
         * @return 缓存文件夹 如果没有SD卡或SD卡有问题则返回内存缓存目录，否则优先返回SD卡缓存目录
         */
        fun getCacheDirectory(context: Context?, type: String?): File? {
            var appCacheDir = getExternalCacheDirectory(context!!, type!!)
            if (appCacheDir == null) {
                appCacheDir = getInternalCacheDirectory(context, type)
            }
            if (appCacheDir == null) {
                Log.e("getCacheDirectory", "getCacheDirectory fail ,the reason is mobile phone unknown exception !")
            } else {
                if (!appCacheDir.exists() && !appCacheDir.mkdirs()) {
                    Log.e("getCacheDirectory", "getCacheDirectory fail ,the reason is make directory fail !")
                }
            }
            return appCacheDir
        }

        /**
         * 获取内存缓存目录
         * @param type 子目录，可以为空，为空直接返回一级目录
         * @return 缓存目录文件夹 或 null（创建目录文件失败）
         * 注：该方法获取的目录是能供当前应用自己使用，外部应用没有读写权限，如 系统相机应用
         */
        private fun getInternalCacheDirectory(context: Context, type: String): File? {
            val appCacheDir: File? = if (TextUtils.isEmpty(type)) {
                context.cacheDir // /data/data/app_package_name/cache
            } else {
                File(context.filesDir, type) // /data/data/app_package_name/files/type
            }
            if (!appCacheDir!!.exists() && !appCacheDir.mkdirs()) {
                Log.e(tag, "getInternalDirectory fail ,the reason is make directory fail !")
                return null
            }
            return appCacheDir
        }

        fun close(resource: Closeable?) {
            try {
                if (resource == null) {
                    return
                }
                resource.close()
            } catch (e: Exception) {
                Log.w(tag, e)
            }
        }
    }

}