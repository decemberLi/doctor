package com.emedclouds.doctor.common.document.viewmodel

import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.text.TextUtils
import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.emedclouds.doctor.common.document.entity.Document
import com.emedclouds.doctor.common.download.DownloadError
import com.emedclouds.doctor.common.download.DownloadListener
import com.emedclouds.doctor.common.download.DownloadManager
import com.emedclouds.doctor.common.download.FileDownloadEntity
import com.emedclouds.doctor.utils.FileUtil
import com.emedclouds.doctor.utils.Md5Tool
import java.io.File

enum class State {
    LOADING,
    POPULATE,
    FAILURE
}

class DocumentViewModelFactory(private val ctx: Context, private val url: String) :
        ViewModelProvider.Factory {

    override fun <T : ViewModel?> create(modelClass: Class<T>): T {
        return modelClass.getConstructor(Context::class.java, String::class.java)
                .newInstance(ctx, url)
    }

}

class DocumentViewModel(val context: Context, val url: String) : ViewModel() {
    companion object {
        val TAG = DocumentViewModel::class.java.simpleName
    }

    val document: MutableLiveData<Document> by lazy {
        MutableLiveData<Document>()
    }

    val state: MutableLiveData<State> by lazy {
        MutableLiveData<State>()
    }

    val docBundle: MutableLiveData<Bundle> by lazy {
        MutableLiveData<Bundle>()
    }

    fun startPreview() {
        if (TextUtils.isEmpty(url)) {
            Log.d(TAG, "Error param, url is -> [$url]")
            state.value = State.FAILURE
            return
        }
        val uri = Uri.parse(url)
        val path = uri?.path
        if (path == null || TextUtils.isEmpty(path)) {
            Log.d(TAG, "Error param, url path is null")
            return
        }
        val suffix = path.substring(path.lastIndexOf('.') + 1)
        if (TextUtils.isEmpty(suffix)) {
            Log.d(TAG, "Cannot support file type")
            return
        }

        val destDir = FileUtil.getCacheDirectory(context, Environment.DIRECTORY_DOCUMENTS)
        if (destDir == null) {
            Log.d(TAG, "Create file error, destDir is -> [$destDir]")
            state.value = State.FAILURE
            return
        }
        val key = Md5Tool.hashKey("${Uri.parse(url).scheme}${Uri.parse(url).host}${Uri.parse(url).path}")
        val destFile = File(destDir, "$key.$suffix")
        // 删除文件
        destFile.deleteOnExit()
        destFile.createNewFile()
        val request = FileDownloadEntity(url, destFile)
        DownloadManager.instance.download(request, object : DownloadListener {
            override fun onStart() {
                state.value = State.LOADING
            }

            override fun onProgress(total: Long, process: Long) {
                val per = (process.toDouble() / total) * 100
                Log.d(TAG, "progress -> $per%")
            }

            override fun onComplete(entity: FileDownloadEntity) {
                val doc = Document(entity.savePath.absolutePath, suffix, false)
                document.value = doc
                val bundle = Bundle().apply {
                    putString("filePath", doc.filePath)
                    putString("tempPath", FileUtil.getCacheDirectory(
                            context,
                            Environment.DIRECTORY_DOCUMENTS)?.absolutePath ?: "")
                }
                state.value = State.POPULATE
                docBundle.value = bundle
            }

            override fun onError(error: DownloadError) {
                state.value = State.FAILURE
            }

        })
    }

}