package com.emedclouds.doctor.pages.common.ocr

import android.content.pm.PackageManager
import android.graphics.*
import android.os.Bundle
import android.util.Log
import android.util.Size
import androidx.activity.ComponentActivity
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import com.emedclouds.doctor.R
import com.emedclouds.doctor.utils.REQUEST_CODE_CAMERA_PERMISSION
import com.emedclouds.doctor.utils.checkCameraPermission
import com.emedclouds.doctor.utils.requestCameraPermission
import kotlinx.android.synthetic.main.activity_scan_card_layout.*
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer
import java.util.concurrent.Executors

class ScanCardActivity : ComponentActivity() {

    companion object {
        const val TAG = "ScanCardActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_scan_card_layout)
        if (!checkCameraPermission(this)) {
            requestCameraPermission(this, REQUEST_CODE_CAMERA_PERMISSION)
        } else {
            startCamera()
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            REQUEST_CODE_CAMERA_PERMISSION -> {
                for (i in grantResults) {
                    if (i == PackageManager.PERMISSION_GRANTED) {
                        startCamera()
                        return
                    }
                }
            }
        }
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener(Runnable {
            // Used to bind the lifecycle of cameras to the lifecycle owner
            val cameraProvider: ProcessCameraProvider = cameraProviderFuture.get()

            // Preview
            val preview = Preview.Builder()
                    .build()
                    .also {
                        Log.d(TAG, "startCamera: -----------------------------------------------")
                        it.setSurfaceProvider(mScanCardPreviewView.createSurfaceProvider())
                    }

            // Select back camera as a default
            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            try {

                val imageAnalysis = ImageAnalysis.Builder()
                        .setTargetResolution(Size(1280, 720))
                        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                        .build()
                imageAnalysis.setAnalyzer(Executors.newSingleThreadExecutor(), ImageAnalysis.Analyzer { image ->
                    Thread {
                        val planes = image.planes
                        for (i in 0 until planes.size) {
                            Log.i(TAG, "pixelStride  " + planes[i].getPixelStride())
                            Log.i(TAG, "rowStride   " + planes.get(i).getRowStride())
                            Log.i(TAG, "width  " + image.width)
                            Log.i(TAG, "height  " + image.height)
                            Log.i(TAG, "Finished reading data from plane  $i")
                        }

                        //cameraX 获取yuv
                        val yBuffer: ByteBuffer = planes.get(0).getBuffer()
                        val uBuffer: ByteBuffer = planes.get(1).getBuffer()
                        val vBuffer: ByteBuffer = planes.get(2).getBuffer()
                        val ySize: Int = yBuffer.remaining()
                        val uSize: Int = uBuffer.remaining()
                        val vSize: Int = vBuffer.remaining()
                        val nv21 = ByteArray(ySize + uSize + vSize)
                        yBuffer.get(nv21, 0, ySize)
                        vBuffer.get(nv21, ySize, vSize)
                        uBuffer.get(nv21, ySize + vSize, uSize)

                        //开始时间
                        val start = System.currentTimeMillis()
                        //获取yuvImage
                        val yuvImage = YuvImage(nv21, ImageFormat.NV21, image.width, image.height, null)
                        //输出流
                        val out = ByteArrayOutputStream()
                        //压缩写入out
                        yuvImage.compressToJpeg(Rect(0, 0, yuvImage.getWidth(), yuvImage.getHeight()), 50, out)
                        //转数组
                        val imageBytes: ByteArray = out.toByteArray()
                        //生成bitmap
                        val bitmap: Bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
                        //旋转bitmap
                        val rotateBitmap: Bitmap? = rotateBitmap(bitmap, 90f)
                        //结束时间
                        val end = System.currentTimeMillis()
                        runOnUiThread {
//                            imageView.setImageBitmap(rotateBitmap)
                            Log.e(TAG, "耗时: " + (end - start))
                            //关闭
                            image.close()
                        }
                    }.start()
                })
                // Unbind use cases before rebinding
                cameraProvider.unbindAll()

                // Bind use cases to camera
                cameraProvider.bindToLifecycle(
                        this, cameraSelector, preview, imageAnalysis
                )
            } catch (exc: Exception) {
                Log.e(TAG, "Use case binding failed", exc)
            }

        }, ContextCompat.getMainExecutor(this))
    }

    private fun rotateBitmap(origin: Bitmap?, alpha: Float): Bitmap? {
        if (origin == null) {
            return null
        }
        val width = origin.width
        val height = origin.height
        val matrix = Matrix()
        matrix.setRotate(alpha)
        // 围绕原地进行旋转
        val newBM = Bitmap.createBitmap(origin, 0, 0, width, height, matrix, false)
        if (newBM == origin) {
            return newBM
        }
        origin.recycle()
        return newBM
    }

}