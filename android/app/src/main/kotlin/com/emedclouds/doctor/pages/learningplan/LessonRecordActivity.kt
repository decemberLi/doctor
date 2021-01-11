package com.emedclouds.doctor.pages.learningplan

import android.Manifest.permission.*
import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Intent
import android.content.pm.PackageManager.PERMISSION_DENIED
import android.graphics.Bitmap
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.*
import android.util.DisplayMetrics
import android.util.Log
import android.view.View
import android.view.Window
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import com.emedclouds.doctor.R
import com.emedclouds.doctor.utils.*
import com.emedclouds.doctor.widgets.ZoomImageView
import com.shockwave.pdfium.PdfDocument
import com.shockwave.pdfium.PdfiumCore
import kotlinx.android.synthetic.main.activity_lesson_record_layout.*
import java.io.File

class LessonRecordActivity : AppCompatActivity() {

    private val tag = LessonRecordActivity::class.simpleName

    companion object {
        private const val PDF_URL =
//            "https://static.e-medclouds.com/web/other/protocols/doctor_privacy_app.pdf"
                "https://static.e-medclouds.com/web/other/protocols/privacy.pdf"
    }

    private val statusReady = 0
    private val statusPlaying = 1
    private val statusPause = 2
    private val statusFinish = 3

    private lateinit var mPdfContentView: ZoomImageView
    private lateinit var core: PdfiumCore
    private lateinit var projectionManager: MediaProjectionManager
    private var document: PdfDocument? = null
    private var count: Int = 0
    private var mCurrentPage: Int = 0
    private var mIsInitiated = false
    private lateinit var mRecordHandler: MediaRecorderThread
    private lateinit var mProjection: MediaProjection
    private var mCurrentStatus = 0
    private val mUserId = "userId"
    private lateinit var mRecordThread: Thread

    private var duration = 1
    private var mIsPause = false
    private val mHandler = Handler()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_lesson_record_layout)
        mPdfContentView = findViewById(R.id.pdfViewer)
        lessonRecordBackBtn.setOnClickListener { finish() }
        lessonRecordBtnAction.setOnClickListener {
            lessonRecordBackBtn.visibility = View.GONE
            if (mCurrentStatus == statusFinish) {
                mRecordThread.start()
                mCurrentStatus = statusPlaying
                updateBtnStatus()
                return@setOnClickListener
            }
            if (mIsInitiated) {
                switchAction()
                return@setOnClickListener
            }
            mIsInitiated = true

            if (!checkCameraPermission(applicationContext)) {
                requestCameraPermission(this@LessonRecordActivity, REQUEST_CODE_CAMERA_PERMISSION)
            } else {
                startCamera()
                showCameraViewIfNeeded(true)
            }

            if (!checkMicPermission(applicationContext)) {
                requestMicPermission(this@LessonRecordActivity, REQUEST_CODE_MIC_PERMISSION)
            } else {
                startScreen()
            }
        }
        lessonRecordBtnFinish.setOnClickListener {
            mCurrentStatus = statusFinish
            mRecordHandler.release()
            showDialog()
        }
        populateUI()

        if (checkExternalPermission(applicationContext)) {
            requestExternalStoragePermission(this, REQUEST_CODE_EXTERNAL_STORAGE_PERMISSION)
        } else {
            initPdfBoard()
        }
        mCurrentStatus = statusReady
        updateBtnStatus()
        showGuideIfNeeded()
    }

    override fun onResume() {
        super.onResume()
    }

    private fun showGuideIfNeeded() {
        val refs = getSharedPreferences(LessonRecordGuidActivity.keyLessonRefsName, MODE_PRIVATE)
        if (!refs.getBoolean(LessonRecordGuidActivity.getCacheKey(mUserId), false)) {
            LessonRecordGuidActivity.startGuide(this, mUserId)
        }
    }

    private fun startScreen() {
        projectionManager =
                getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startActivityForResult(projectionManager.createScreenCaptureIntent(), REQUEST_CODE_SCREEN_RECORD_PERMISSION)
    }

    private fun initPdfBoard() {
        val pdfFilePath = downloadFile()
        if (pdfFilePath != null) {
            core = PdfiumCore(application)
            val pfd = ParcelFileDescriptor.open(pdfFilePath, ParcelFileDescriptor.MODE_READ_ONLY)
            document = core.newDocument(pfd)
            count = core.getPageCount(document)
            renderPage()
        }
    }

    private fun renderPage() {
        if (document == null || count < 1) {
            return
        }
        val displayMetrics = DisplayMetrics()
        windowManager.defaultDisplay.getMetrics(displayMetrics)
        val dpi = displayMetrics.density
        core.openPage(document, mCurrentPage)
        val bitmap = Bitmap.createBitmap(
                core.getPageWidthPoint(document, mCurrentPage) * dpi.toInt(),
                core.getPageHeightPoint(document, mCurrentPage) * dpi.toInt(),
                Bitmap.Config.ARGB_8888
        )
        core.renderPageBitmap(
                document,
                bitmap,
                mCurrentPage,
                0,
                0,
                core.getPageWidthPoint(document, mCurrentPage) * dpi.toInt(),
                core.getPageHeightPoint(document, mCurrentPage) * dpi.toInt(),
                false
        )

        mPdfContentView.setImageBitmap(bitmap)
        mPdfContentView.invalidate()
    }

    private fun downloadFile(): File? {
        val externalFilesDir = getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS) ?: return null
        if (!externalFilesDir.exists() && !externalFilesDir.mkdirs()) {
            return null
        }

        // download
        return File(externalFilesDir, "doctor_privacy_app.pdf")
    }

    private fun populateUI() {
        doctorName.text = "懂医生"
        doctorHospitalName.text = "四川省成都市第二人民医院医院医院医院"
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_SCREEN_RECORD_PERMISSION && resultCode == RESULT_OK) {
            if (data == null) {
                return
            }
            doRecord(resultCode, data)
        }
    }

    private fun doRecord(resultCode: Int, data: Intent) {
        mProjection = projectionManager.getMediaProjection(resultCode, data)
        val externalFilesDir = File(getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS), "record")
        if (externalFilesDir.mkdirs()) {
            return
        }
        mRecordHandler = MediaRecorderThread(
                720,
                480,
                resources.configuration.densityDpi,
                externalFilesDir.absolutePath,
                mProjection
        )
        mRecordThread = Thread(mRecordHandler)
        mRecordThread.start()
        updateTimeView(true)
        mCurrentStatus = statusPlaying
        updateBtnStatus()
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            REQUEST_CODE_MIC_PERMISSION -> {
                for (i in grantResults) {
                    if (grantResults[i] == PERMISSION_DENIED) {
                        Toast.makeText(applicationContext, "无麦克风权限无法录屏", Toast.LENGTH_SHORT).show()
                        return
                    }
                }
            }
            REQUEST_CODE_CAMERA_PERMISSION -> {
                for (i in grantResults) {
                    if (grantResults[i] == PERMISSION_DENIED) {
                        showCameraViewIfNeeded(false)
                        return
                    }
                }
                showCameraViewIfNeeded(true)
                startCamera()
            }
            REQUEST_CODE_EXTERNAL_STORAGE_PERMISSION -> {
                for (i in grantResults) {
                    if (grantResults[i] == PERMISSION_DENIED) {
                        return
                    }
                }
                initPdfBoard()
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
                        it.setSurfaceProvider(doctorAvatarPreview.createSurfaceProvider())
                    }

            // Select back camera as a default
            val cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA

            try {
                // Unbind use cases before rebinding
                cameraProvider.unbindAll()

                // Bind use cases to camera
                cameraProvider.bindToLifecycle(
                        this, cameraSelector, preview
                )

            } catch (exc: Exception) {
                Log.e(tag, "Use case binding failed", exc)
            }

        }, ContextCompat.getMainExecutor(this))
    }

    private fun showCameraViewIfNeeded(visibility: Boolean) {
        if (visibility) {
            doctorAvatarPreview.visibility = View.VISIBLE
            imageDoctorAvatar.visibility = View.GONE
        } else {
            doctorAvatarPreview.visibility = View.GONE
            imageDoctorAvatar.visibility = View.VISIBLE
        }
    }

    private fun switchAction() {
        when (mCurrentStatus) {
            statusPlaying -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    mRecordHandler.pause()
                } else {
                    mRecordHandler.release()
                }
                updateTimeView(false)
                mCurrentStatus = statusPause
            }
            statusPause -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    mRecordHandler.resume()
                } else {
                    mRecordThread.start()
                }
                updateTimeView(true)
                mCurrentStatus = statusPlaying
            }
        }
        updateBtnStatus()
    }

    private fun updateBtnStatus() {
        when (mCurrentStatus) {
            statusFinish -> {
                lessonRecordBtnAction.setImageResource(R.mipmap.btn_record_start)
                lessonRecordBtnFinish.visibility = View.GONE
            }
            statusReady -> {
                lessonRecordBtnAction.setImageResource(R.mipmap.btn_record_start)
                lessonRecordBtnFinish.visibility = View.GONE
            }
            statusPlaying -> {
                lessonRecordBtnAction.setImageResource(R.mipmap.btn_record_pause)
                lessonRecordBtnFinish.visibility = View.GONE
            }
            statusPause -> {
                lessonRecordBtnAction.setImageResource(R.mipmap.btn_record_start)
                lessonRecordBtnFinish.visibility = View.VISIBLE
            }
        }
    }

    private fun showDialog() {
        val dialog = Dialog(this)
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog.setContentView(R.layout.dialog_record_layout)
        dialog.setCancelable(false)
        dialog.findViewById<TextView>(R.id.btnReCord).setOnClickListener {
            mCurrentStatus = statusFinish
            updateBtnStatus()
            if (dialog.isShowing) {
                dialog.dismiss()
            }
        }
        dialog.findViewById<TextView>(R.id.btnUpload).setOnClickListener {
            if (dialog.isShowing) {
                dialog.dismiss()
            }
        }
        dialog.show()
    }

    private val myRunner: Runnable = object : Runnable {
        @SuppressLint("SetTextI18n")
        override fun run() {
            if (!mIsPause) {
                return
            }
            timerView.text = formatTime(duration++)
            mHandler.postDelayed(this, 1000)
        }
    }

    private fun formatTime(duration: Int): String {
        val minute = duration / 60
        val seconds = duration % 60
        val strMinute = if (minute < 10) {
            "0$minute"
        } else {
            "$minute"
        }
        val strSeconds = if (seconds < 10) {
            "0$seconds"
        } else {
            "$seconds"
        }
        return "$strMinute:$strSeconds"
    }

    private fun updateTimeView(isPause: Boolean) {
        this.mIsPause = isPause
        mHandler.post(myRunner)
    }

}