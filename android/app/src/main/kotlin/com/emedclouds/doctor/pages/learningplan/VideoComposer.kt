package com.emedclouds.doctor.pages.learningplan

import android.util.Log
import java.io.File
import java.lang.Exception
import java.util.concurrent.Executors


interface OnFileComposeCallback {
    fun onFinished(success: Boolean, path: String)
    fun onCombineProcessing()
    fun onStart()
}

class VideoComposer {

    companion object {
        fun merge(direction: String, callback: OnFileComposeCallback) {
            Executors.newSingleThreadExecutor().execute {
                val file = File(direction)
                if (!file.exists()) {
                    callback.onFinished(false, "")
                    return@execute
                }
                val lists = file.list()
                if (lists == null || lists.isEmpty()) {
                    callback.onFinished(false, "")
                    return@execute
                }
                val videoList = ArrayList<String>()
                for (each in lists) {
                    videoList.add("$direction/$each")
                }
                val destFilePath = File(direction, "merged_file.mp4").absolutePath
                VideoCombiner(videoList, destFilePath,
                        object : VideoCombiner.VideoCombineListener {
                            override fun onCombineStart() {
                                Log.d(MediaRecorderThread.TAG, "onCombineStart: ")
                                callback.onStart()
                            }

                            override fun onCombineProcessing(current: Int, sum: Int) {
                                Log.d(MediaRecorderThread.TAG, "onCombineProcessing: ")
                                callback.onCombineProcessing()
                            }

                            override fun onCombineFinished(success: Boolean) {
                                Log.d(MediaRecorderThread.TAG, "onCombineFinished: ")
                                callback.onFinished(success, destFilePath)
                            }
                        }).apply {
                    try {
                        combineVideo()
                    }catch (e:Exception){
                        callback.onFinished(false, destFilePath)
                    }
                }
            }
        }
    }

}