package com.emedclouds.doctor.pages.learningplan

import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.CamcorderProfile
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.os.Build
import android.os.Build.VERSION_CODES.N
import android.util.Log
import java.io.File

class MediaRecorderThread(
        private var mWidth: Int,
        private var mHeight: Int,
        private var mDpi: Int,
        private var mDstPath: String,
        private var mediaProjection: MediaProjection
) : Runnable {
    companion object {
        const val TAG = "MediaRecorderThread"
    }

    private lateinit var mMediaRecorder: MediaRecorder
    private lateinit var mVirtualDisplay: VirtualDisplay
    private var mFileSequence = 0


    override fun run() {
        try {
            mMediaRecorder = MediaRecorder()
            initMediaRecorder()
            mediaProjection.createVirtualDisplay(
                    "screenRecorder", mWidth, mHeight, mDpi,
                    DisplayManager.VIRTUAL_DISPLAY_FLAG_PUBLIC, mMediaRecorder.surface,
                    null, null
            )
            mMediaRecorder.start()
        } catch (e: Exception) {
            e.printStackTrace()
            Log.w(TAG, "屏幕录制发生异常，${e.printStackTrace()}")
        } finally {
            //release()
        }
    }

    private fun deleteAllFile() {
        val fileList = File(mDstPath).list() ?: return
        for (each in fileList) {
            File(each).deleteOnExit()
        }
    }

    private fun initMediaRecorder() {
        deleteAllFile()
        val profile = CamcorderProfile.get(CamcorderProfile.QUALITY_720P)
        // 设置视频来源
        mMediaRecorder.setVideoSource(MediaRecorder.VideoSource.SURFACE)
        mMediaRecorder.setAudioSource(MediaRecorder.AudioSource.DEFAULT)
        mMediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        mMediaRecorder.setOutputFile(File(mDstPath, "${mFileSequence++}.mp4").absolutePath)
        mMediaRecorder.setVideoSize(mWidth, mHeight)
        mMediaRecorder.setVideoFrameRate(profile.videoFrameRate)
//        mMediaRecorder.setVideoEncoder(profile.videoCodec)
        //比特率
        mMediaRecorder.setVideoEncodingBitRate(profile.videoBitRate)

        //视频编码格式
        mMediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB)

        mMediaRecorder.setAudioChannels(profile.audioChannels)
        mMediaRecorder.setAudioSamplingRate(profile.audioSampleRate)
        mMediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264)
        //准备 到这里 就可以开始录制视频了
        mMediaRecorder.prepare()
    }

    fun release() {
        mMediaRecorder.setOnErrorListener(null)
        mMediaRecorder.stop()
        mMediaRecorder.release()
    }

    fun reRecord() {
        mFileSequence = 0
        initMediaRecorder()
        mMediaRecorder.start()
    }

    fun stop() {
        try {
            mMediaRecorder.stop()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun pause() {
        if (Build.VERSION.SDK_INT >= N) {
            mMediaRecorder.pause()
        } else {
            release()
        }
    }

    fun resume() {
        if (Build.VERSION.SDK_INT >= N) {
            mMediaRecorder.resume()
        } else {
            mMediaRecorder.setOutputFile(File(mDstPath, "${mFileSequence++}.mp4").absolutePath)
            mMediaRecorder.prepare()
            mMediaRecorder.start()
        }

    }

    private fun merge() {
        val file = File(mDstPath)
        if (!file.exists()) {
            return
        }
        val lists = file.list()
        if (lists == null || lists.isEmpty()) {
            return
        }
        val videoList = ArrayList<String>()
        for (each in lists) {
            videoList.add("$mDstPath/$each")
        }

        VideoCombiner(videoList, File(mDstPath, "merged").absolutePath,
                object : VideoCombiner.VideoCombineListener {
                    override fun onCombineStart() {
                        Log.d(TAG, "onCombineStart: ")
                    }

                    override fun onCombineProcessing(current: Int, sum: Int) {
                        Log.d(TAG, "onCombineProcessing: ")
                    }

                    override fun onCombineFinished(success: Boolean) {
                        Log.d(TAG, "onCombineFinished: ")
                    }
                })
    }
}