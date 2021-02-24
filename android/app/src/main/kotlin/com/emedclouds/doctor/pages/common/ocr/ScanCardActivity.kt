package com.emedclouds.doctor.pages.common.ocr

import android.content.pm.PackageManager
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
import com.example.flutterimagecompress.logger.log
import kotlinx.android.synthetic.main.activity_scan_card_layout.*

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

                val imageCapture = ImageCapture.Builder()
                        .setTargetRotation(mScanCardPreviewView.display.rotation)
                        .build()
                // Unbind use cases before rebinding
                cameraProvider.unbindAll()

                // Bind use cases to camera
                cameraProvider.bindToLifecycle(
                        this, cameraSelector, preview
                )


            } catch (exc: Exception) {
                Log.e(TAG, "Use case binding failed", exc)
            }

        }, ContextCompat.getMainExecutor(this))
    }


}