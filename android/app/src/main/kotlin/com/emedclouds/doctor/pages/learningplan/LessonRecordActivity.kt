package com.emedclouds.doctor.pages.learningplan

import android.Manifest.permission.*
import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager.PERMISSION_DENIED
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.pdf.PdfRenderer
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.*
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.util.DisplayMetrics
import android.util.Log
import android.view.KeyEvent
import android.view.View
import android.view.Window
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import com.emedclouds.doctor.MainActivity
import com.emedclouds.doctor.R
import com.emedclouds.doctor.toast.CustomToast
import com.emedclouds.doctor.utils.*
import com.emedclouds.doctor.widgets.ZoomImageView
import com.kaopiz.kprogresshud.KProgressHUD
import kotlinx.android.synthetic.main.activity_lesson_record_layout.*
import kotlinx.android.synthetic.main.dialog_record_layout.*
import org.json.JSONObject
import java.io.File

class LessonRecordActivity : AppCompatActivity() {

    private val tag = LessonRecordActivity::class.simpleName

    companion object {
        fun start(act: MainActivity, path: String, name: String, userId: String, hospital: String, title: String) {
            val intent = Intent(act, LessonRecordActivity::class.java)
            intent.putExtra("path", path)
            intent.putExtra("name", name)
            intent.putExtra("userId", userId)
            intent.putExtra("hospital", hospital)
            intent.putExtra("title", title)
            act.startActivity(intent)
        }
    }

    private val statusReady = 0
    private val statusPlaying = 1
    private val statusPause = 2
    private val statusFinish = 3

    private lateinit var mPdfContentView: ZoomImageView
    private lateinit var mPdfRender: PdfRenderer
    private lateinit var projectionManager: MediaProjectionManager
    private var count: Int = 0
    private var mCurrentPage: Int = 0
    private var mIsInitiated = false
    private lateinit var mRecordHandler: MediaRecorderThread
    private var mProjection: MediaProjection? = null
    private var mCurrentStatus = 0

    private var mDuration = 1
    private var mIsPause = false
    private val mHandler = Handler()

    private var mPath: String? = null
    private var mDoctorName: String? = null
    private var mUserId: String? = null
    private var mHospital: String? = null
    private var mTitle: String? = null

    private var mPhoneStateListener: PhoneStateListener? = null
    private val myRunner: Runnable = object : Runnable {
        @SuppressLint("SetTextI18n")
        override fun run() {
            if (!mIsPause) {
                return
            }
            timerView.text = formatTime(mDuration++)
            mHandler.postDelayed(this, 1000)
        }
    }

    private fun initParam() {
        mPath = intent.getStringExtra("path")
        mDoctorName = intent.getStringExtra("name")
        mUserId = intent.getStringExtra("userId")
        mHospital = intent.getStringExtra("hospital")
        mTitle = intent.getStringExtra("title")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_lesson_record_layout)
        mPdfContentView = findViewById(R.id.pdfViewer)
        initParam()
        lessonRecordBackBtn.setOnClickListener { finish() }
        lessonRecordBtnAction.setOnClickListener {
//            if (mCurrentStatus == statusFinish) {
//                mRecordHandler.reRecord()
//                mCurrentStatus = statusPlaying
//                updateBtnStatus()
//                return@setOnClickListener
//            }
            if (mIsInitiated && mCurrentStatus != statusFinish) {
                switchAction()
                return@setOnClickListener
            }

            if (checkCameraPermission(applicationContext) && checkMicPermission(applicationContext)) {
                startCamera()
                showCameraViewIfNeeded(true)
                startScreen()
                return@setOnClickListener
            }

            if (!checkCameraPermission(applicationContext)) {
                requestCameraPermission(this@LessonRecordActivity, REQUEST_CODE_CAMERA_PERMISSION)
            } else {
                checkMicPermission()
                showCameraViewIfNeeded(true)
                startCamera()
            }
        }
        lessonRecordBtnFinish.setOnClickListener {
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
        pdfViewer.setBackgroundColor(Color.WHITE)
        pdfViewer.setOnPositionClickListener(object : ZoomImageView.OnPositionClickListener {
            override fun onLeftClick(view: View?) {
                mCurrentPage = if (++mCurrentPage >= count - 1) {
                    count - 1
                } else {
                    mCurrentPage
                }
                renderPage()
            }

            override fun onRightClick(view: View?) {
                mCurrentPage = if (--mCurrentPage < 0) {
                    0
                } else {
                    mCurrentPage
                }
                renderPage()
            }

        })
        registerPhoneStateListener()
    }

    override fun onPause() {
        super.onPause()
        if (mIsInitiated && mCurrentStatus == statusPlaying) {
            switchAction()
        }
    }

    override fun onDestroy() {
        mHandler.removeCallbacks(myRunner)
        if (mProjection != null) {
            mProjection?.stop()
        }
        if(mPdfRender != null){
            mPdfRender.close()
        }
        super.onDestroy()
    }

    private fun showGuideIfNeeded() {
        val refs = getSharedPreferences(LessonRecordGuidActivity.keyLessonRefsName, MODE_PRIVATE)
        if (!refs.getBoolean(LessonRecordGuidActivity.getCacheKey(mUserId), false) && mUserId != null) {
            LessonRecordGuidActivity.startGuide(this, mUserId!!)
        }
    }

    private fun startScreen() {
        projectionManager =
                getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startActivityForResult(projectionManager.createScreenCaptureIntent(), REQUEST_CODE_SCREEN_RECORD_PERMISSION)
    }

    private fun initPdfBoard() {
        if (mPath != null) {
            val pdfFileDesc = ParcelFileDescriptor.open(File(mPath), ParcelFileDescriptor.MODE_READ_ONLY)
            mPdfRender = PdfRenderer(pdfFileDesc)
            count = mPdfRender.pageCount
            renderPage()
        }
    }

    private fun renderPage() {
        val displayMetrics = DisplayMetrics()
        windowManager.defaultDisplay.getMetrics(displayMetrics)
        val dpi = displayMetrics.density
        val page = mPdfRender.openPage(mCurrentPage);
        val bitmap = Bitmap.createBitmap(
                page.width * dpi.toInt(),
                page.height * dpi.toInt(),
                Bitmap.Config.ARGB_8888
        )
        page.render(bitmap,null,null,PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)

        mPdfContentView.setImageBitmap(bitmap)
        mPdfContentView.invalidate()
        page.close()
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
        doctorName.text = mDoctorName
        doctorHospitalName.text = mHospital
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_SCREEN_RECORD_PERMISSION && resultCode == RESULT_OK) {
            if (resultCode != RESULT_OK) {
                Toast.makeText(this, "需开启系统录屏方可开启录制，请重试", Toast.LENGTH_LONG).show()
                return
            }
            if (data == null) {
                return
            }
            mIsInitiated = true
            doRecord(resultCode, data)
        }
    }

    private fun doRecord(resultCode: Int, data: Intent) {
        val externalFilesDir = File(getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS), "record")
        mProjection = projectionManager.getMediaProjection(resultCode, data)
        if (!externalFilesDir.exists() && !externalFilesDir.mkdirs()) {
            return
        }
        if (mProjection == null) {
            return
        }
        mRecordHandler = MediaRecorderThread(
                720,
                480,
                resources.configuration.densityDpi,
                externalFilesDir.absolutePath,
                mProjection!!
        )
        mRecordHandler.run()
        lessonRecordBackBtn.visibility = View.GONE
        updateTimeView(true)
        mCurrentStatus = statusPlaying
        updateBtnStatus()
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            REQUEST_CODE_MIC_PERMISSION -> {
                for (i in grantResults) {
                    if (i == PERMISSION_DENIED) {
                        Toast.makeText(this, "需授权麦克风方可开启录制，请重试", Toast.LENGTH_LONG).show()
                        return
                    }
                    startScreen()
                }
            }
            REQUEST_CODE_CAMERA_PERMISSION -> {
                checkMicPermission()
                for (i in grantResults) {
                    if (i == PERMISSION_DENIED) {
                        showCameraViewIfNeeded(false)
                        return
                    }
                }
                showCameraViewIfNeeded(true)
                startCamera()
            }
            REQUEST_CODE_EXTERNAL_STORAGE_PERMISSION -> {
                for (i in grantResults) {
                    if (i == PERMISSION_DENIED) {
                        return
                    }
                }
                initPdfBoard()
            }
        }
    }

    private fun checkMicPermission() {
        if (!checkMicPermission(applicationContext)) {
            requestMicPermission(this@LessonRecordActivity, REQUEST_CODE_MIC_PERMISSION)
        } else {
            startScreen()
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
                mRecordHandler.pause()
                updateTimeView(false)
                mCurrentStatus = statusPause
            }
            statusPause -> {
                mRecordHandler.resume()
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
            lessonRecordBackBtn.visibility = View.VISIBLE
            mCurrentStatus = statusFinish
            updateBtnStatus()
            if (dialog.isShowing) {
                dialog.dismiss()
            }
        }
        val editText = dialog.findViewById<EditText>(R.id.recordEditText)
        mTitle?.let {
            editText.setText(it)
        }
        dialog.findViewById<TextView>(R.id.btnUpload).setOnClickListener {
            if (editText == null || editText.text.isEmpty()) {
                Toast.makeText(this@LessonRecordActivity, "请输入视频标题", Toast.LENGTH_LONG).show()
                return@setOnClickListener
            }
            if (mCurrentStatus != statusFinish) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    mRecordHandler.stop()
                } else {
                    mRecordHandler.release()
                }
            }
            mCurrentStatus = statusFinish
            val json = JSONObject().apply {
                if (editText.text == null || editText.text.isEmpty()) {
                    mTitle = editText.text.toString()
                }
                put("title", mTitle)
                put("duration", mDuration)
                val externalFilesDir = File(getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS), "record")
                put("path", File(externalFilesDir, "0.mp4"))
            }
            val kProgressHUD = KProgressHUD.create(this@LessonRecordActivity)
                    .setLabel("上传中...")
                    .setCancellable(false)
                    .setAnimationSpeed(2)
                    .setDimAmount(0.5f)
                    .show()
            ChannelManager.instance.callFlutter("uploadLearnVideo", json.toString(), object : MethodChannelResultAdapter() {
                override fun success(result: Any?) {
                    super.success(result)
                    if (kProgressHUD.isShowing) {
                        kProgressHUD.dismiss()
                    }
                    if (result == null) {
                        CustomToast.showSuccessToast(applicationContext, R.string.upload_success)

                        finish()
                    } else {
                        CustomToast.showFailureToast(applicationContext, R.string.upload_failure)
                    }
                }
            })
            if (dialog.isShowing) {
                dialog.dismiss()
            }
        }
        dialog.findViewById<ImageView>(R.id.btnCloseDialog).setOnClickListener {
            if (dialog.isShowing) {
                dialog.dismiss()
            }
        }
        dialog.show()
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

    private fun registerPhoneStateListener() {
        mPhoneStateListener = object : PhoneStateListener() {
            override fun onCallStateChanged(state: Int, phoneNumber: String?) {
                super.onCallStateChanged(state, phoneNumber)
                when (state) {
                    TelephonyManager.CALL_STATE_RINGING -> {
                        if (mCurrentStatus == statusPlaying) {
                            switchAction()
                        }
                    }
                    TelephonyManager.CALL_STATE_IDLE -> {

                    }
                    TelephonyManager.CALL_STATE_OFFHOOK -> {

                    }
                }
            }

        }
        val telephonyManager: TelephonyManager? = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager?
        telephonyManager?.listen(mPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE)
    }

}


