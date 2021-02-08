package com.emedclouds.doctor.widgets

import android.annotation.SuppressLint
import android.content.Context
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.TextUtils
import android.text.style.ForegroundColorSpan
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.TextView
import androidx.annotation.StringRes
import androidx.core.widget.doAfterTextChanged
import com.emedclouds.doctor.R

class InputView : FrameLayout {

    companion object {
        private const val DEFAULT_INPUT_TEXT_COUNT = 150
    }

    private val mRootView: View
    private val mInputView: EditText
    private val mCommentHintView: TextView
    private val mTextStatisticsView: TextView
    private val mInputFinishView: TextView
    private var mTextCount = DEFAULT_INPUT_TEXT_COUNT

    constructor(context: Context) : this(context, null)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0)
    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : this(context, attrs, defStyleAttr, 0)

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int, defStyleRes: Int) : super(context, attrs, defStyleAttr, defStyleRes) {
        mRootView = LayoutInflater.from(context).inflate(R.layout.layout_common_input, this)
        mInputView = mRootView.findViewById(R.id.mEditText)
        mCommentHintView = mRootView.findViewById(R.id.mCommentHintView)
        mTextStatisticsView = mRootView.findViewById(R.id.mTextStatisticsView)
        mInputFinishView = mRootView.findViewById(R.id.mInputFinishView)

        mInputView.doAfterTextChanged {
            it?.apply {
                textCount()
            }
        }

        textCount()
    }

    @SuppressLint("SetTextI18n")
    private fun textCount() {
        val length = mInputView.text.length
        val span = SpannableStringBuilder("$length/$mTextCount")
        if (length > 150) {
            val color = context.resources.getColor(R.color.color_fff67777)
            val colorSpan = ForegroundColorSpan(color)
            span.setSpan(colorSpan, 0, "$length".length, Spanned.SPAN_INCLUSIVE_EXCLUSIVE)

        }
        mTextStatisticsView.text = span
    }

    fun setPlaceHolder(inputHint: String) {
        mInputView.hint = if (TextUtils.isEmpty(inputHint)) {
            "请输入"
        } else {
            inputHint
        }
        textCount()
    }

    fun setPlaceHolder(@StringRes inputHint: Int) {
        setPlaceHolder(context.resources.getString(inputHint))
    }

    fun setTopHintText(text: String) {
        if (text.isNotBlank()) {
            mCommentHintView.text = text
            mCommentHintView.visibility = VISIBLE
        } else {
            mCommentHintView.visibility = GONE
        }
    }

    fun setInputText(text: CharSequence) {
        mInputView.setText(text)
    }

    fun maxTextCount(count: Int) {
        mTextCount = count
    }

    fun text(): String {
        return mInputView.text.toString()
    }

    fun publish(runnable: Runnable) {
        mInputFinishView.setOnClickListener {
            runnable.run()
        }
    }

}
