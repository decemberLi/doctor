package com.emedclouds.doctor.common.download

import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Url

interface DownloadFileApi {

    @GET
    fun loadPdfFile(@Url fileUrl: String): Call<ResponseBody>

}