package com.emedclouds.doctor.common.download

enum class DownloadError {
    FAIL_CREATE_FILE,
    FAIL_DOWNLOAD_FILE,
}


interface DownloadListener {

    fun onStart()

    fun onProgress(total: Long, process: Long)

    fun onComplete(entity: FileDownloadEntity)

    fun onError(error: DownloadError)
}