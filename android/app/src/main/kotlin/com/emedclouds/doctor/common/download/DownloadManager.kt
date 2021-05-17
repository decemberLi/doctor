package com.emedclouds.doctor.common.download

import android.util.Log
import okhttp3.ResponseBody
import org.apache.commons.io.IOUtils
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.FileOutputStream
import java.io.InputStream
import java.util.concurrent.Executors

/**
 * 根据 下载 url 做为缓存
 */
class DownloadManager private constructor() {

    companion object {
        val TAG = DownloadManager::class.java.simpleName
        val instance: DownloadManager by lazy(mode = LazyThreadSafetyMode.SYNCHRONIZED) {
            DownloadManager()
        }
    }

    fun download(
            entity: FileDownloadEntity,
            callback: DownloadListener) {

        if (entity.savePath.isDirectory) {
            Log.w(TAG, "${entity.savePath} is not a file.")
            callback.onError(DownloadError.FAIL_CREATE_FILE)
            return
        }

        callback.onStart()
        Executors.newCachedThreadPool().execute {
            doDownload(entity.url, object : Callback<ResponseBody> {
                override fun onResponse(call: Call<ResponseBody>?, response: Response<ResponseBody>?) {
                    if (response?.isSuccessful != true) {
                        callback.onError(DownloadError.FAIL_DOWNLOAD_FILE)
                        return
                    }
                    val rspBody: ResponseBody = response.body()
                    var inStream: InputStream? = null
                    val outStream = FileOutputStream(entity.savePath)
                    try {
                        inStream = rspBody.byteStream()
                        val total = rspBody.contentLength()
                        var sum: Long = 0
                        var len: Int
                        val buffer = ByteArray(1024 * 10)
                        inStream.use { input ->
                            while (input.read(buffer).also { len = it } != -1) {
                                outStream.write(buffer, 0, len)
                                sum += len
                                callback.onProgress(total, sum)
                            }
                        }
                        callback.onProgress(total, sum)
                        outStream.flush()
                        Log.d(TAG, "Download success, save path -> ${entity.savePath.absolutePath}")
                        callback.onComplete(entity)
                    } catch (exception: Exception) {
                        Log.w(TAG, "Download file failure,url -> ${entity.url}", exception)
                        callback.onError(DownloadError.FAIL_DOWNLOAD_FILE)
                    } finally {
                        IOUtils.close(inStream, outStream)
                    }
                }

                override fun onFailure(call: Call<ResponseBody>?, t: Throwable?) {
                    Log.w(TAG, "Download file failure,url -> ${entity.url}", t)
                    callback.onError(DownloadError.FAIL_DOWNLOAD_FILE)
                }
            })
        }
    }

    // 原生目前没有网络请求相关实现，现在具体实现暂时放在这里
    private fun doDownload(url: String, callback: Callback<ResponseBody>) {
        val retrofit = Retrofit.Builder()
                .baseUrl("http://www.baidu.com")
                .addConverterFactory(GsonConverterFactory.create())
                .build()
        val api = retrofit.create(DownloadFileApi::class.java)
        val call: Call<ResponseBody> = api.loadPdfFile(url)
        call.enqueue(callback)
    }

}