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
) {
    companion object {
        const val TAG = "MediaRecorderThread"
    }

    private lateinit var mMediaRecorder: MediaRecorder
    private lateinit var mVirtualDisplay: VirtualDisplay
    private var mFileSequence = 0

    fun prepareMediaRecord() {
        try {
            mMediaRecorder = MediaRecorder()
            initMediaRecorder()
            mediaProjection.createVirtualDisplay(
                    "screenRecorder", mWidth, mHeight, mDpi,
                    DisplayManager.VIRTUAL_DISPLAY_FLAG_PUBLIC, mMediaRecorder.surface,
                    null, null
            )
        } catch (e: Exception) {
            e.printStackTrace()
            Log.w(TAG, "屏幕录制发生异常，${e.printStackTrace()}")
        } finally {
            //release()
        }
    }

    fun deleteAllFile() {
        val fileList = File(mDstPath).list() ?: return
        for (each in fileList) {
            try {
                File(mDstPath, each).delete()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun initMediaRecorder() {
        val profile = CamcorderProfile.get(CamcorderProfile.QUALITY_720P)
        mMediaRecorder.apply {
            // 设置视频来源
            setVideoSource(MediaRecorder.VideoSource.SURFACE)
            setAudioSource(MediaRecorder.AudioSource.VOICE_COMMUNICATION)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setOutputFile(File(mDstPath, "${mFileSequence++}.mp4").absolutePath)
            setVideoSize(mWidth, mHeight)
            setVideoFrameRate(profile.videoFrameRate)
            // mMediaRecorder.setVideoEncoder(profile.videoCodec)
            // 比特率
            setVideoEncodingBitRate(profile.videoBitRate)
            // 视频编码格式
            setAudioEncoder(MediaRecorder.AudioEncoder.HE_AAC)
            setAudioChannels(profile.audioChannels)
            setAudioSamplingRate(profile.audioSampleRate)
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            // 准备 到这里 就可以开始录制视频了
            prepare()
        }
    }

    fun startRecord() {
        mMediaRecorder.start()
    }

    fun recordFinish() {
        if (Build.VERSION.SDK_INT >= N) {
            try {
                mMediaRecorder.stop()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } else {
            // merge data
            mMediaRecorder.apply {
                try {
                    setOnErrorListener(null)
                    stop()
                    reset()
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
    }

    fun pause() {
        if (Build.VERSION.SDK_INT >= N) {
            mMediaRecorder.pause()
        } else {
            mMediaRecorder.apply {
                try {
                    setOnErrorListener(null)
                    stop()
                    reset()
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
    }

    fun resume() {
        if (Build.VERSION.SDK_INT >= N) {
            mMediaRecorder.resume()
        } else {
            mMediaRecorder.apply {
                prepareMediaRecord()
                startRecord()
            }
        }
    }
}