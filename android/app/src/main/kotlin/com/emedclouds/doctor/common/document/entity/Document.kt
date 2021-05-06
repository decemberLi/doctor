package com.emedclouds.doctor.common.document.entity

data class Document(
        val filePath: String,
        val suffix: String,
        var canSupport: Boolean
)
