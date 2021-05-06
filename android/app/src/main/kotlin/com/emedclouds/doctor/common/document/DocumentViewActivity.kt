package com.emedclouds.doctor.common.document

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.animation.Animation
import android.view.animation.LinearInterpolator
import android.view.animation.RotateAnimation
import android.widget.FrameLayout
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.observe
import com.emedclouds.doctor.R
import com.emedclouds.doctor.common.document.viewmodel.DocumentViewModel
import com.emedclouds.doctor.common.document.viewmodel.DocumentViewModelFactory
import com.emedclouds.doctor.common.document.viewmodel.State
import com.emedclouds.doctor.toast.CustomToast
import com.emedclouds.doctor.utils.StatusBarUtil
import com.kaopiz.kprogresshud.KProgressHUD
import com.tencent.smtt.sdk.TbsReaderView
import kotlinx.android.synthetic.main.activity_document_preview.*


class DocumentViewActivity : AppCompatActivity(), TbsReaderView.ReaderCallback {

    companion object {
        fun open(activity: Activity, url: String, title: String) {
            val intent = Intent(activity, DocumentViewActivity::class.java).apply {
                putExtra("url", url)
                putExtra("title", title)
            }
            activity.startActivity(intent)
        }
    }

    private lateinit var mDocumentViewer: TbsReaderView


    private val mViewModel: DocumentViewModel by viewModels {
        DocumentViewModelFactory(this, intent?.getStringExtra("url") ?: "")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        StatusBarUtil.setStatusBarMode(this, true, R.color.white)
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_document_preview)
        val pdfContainer = findViewById<FrameLayout>(R.id.llRootLayout)
        btnBack.setOnClickListener {
            finish()
        }
        tvTitle.text = intent?.getStringExtra("title") ?: ""
        mDocumentViewer = TbsReaderView(this, this)
        val mLoading = KProgressHUD.create(this)
                .setLabel("文档加载中...")
                .setCancellable(true)
                .setAnimationSpeed(2)
                .setDimAmount(0.5f)
        pdfContainer.addView(
                mDocumentViewer,
                FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.MATCH_PARENT,
                        FrameLayout.LayoutParams.MATCH_PARENT))
        mViewModel.state.observe(this) {
            runOnUiThread {
                if (it == State.LOADING) {
                    return@runOnUiThread
                }
                if (mLoading.isShowing) {
                    mLoading.dismiss()
                }
                if (it == State.FAILURE) {
                    CustomToast.showFailureToast(this, "文档加载失败")
                }
            }
        }
        mViewModel.document.observe(this) {
            it.canSupport = mDocumentViewer.preOpen(it.suffix, false)
        }
        mViewModel.docBundle.observe(this) {
            runOnUiThread {
                mDocumentViewer.openFile(it)
            }
        }
        mLoading.show()
        mViewModel.startPreview()
    }


    override fun onCallBackAction(p0: Int?, p1: Any?, p2: Any?) {
    }


    override fun onDestroy() {
        if (this::mDocumentViewer.isInitialized) {
            mDocumentViewer.onStop()
        }
        super.onDestroy()
    }
}