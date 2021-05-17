package com.emedclouds.doctor.common.download

import java.io.File

data class FileDownloadEntity(
        val url: String,
        val savePath: File
)
