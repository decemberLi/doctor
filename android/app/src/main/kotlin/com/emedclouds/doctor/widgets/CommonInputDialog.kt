package com.emedclouds.doctor.widgets

import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.graphics.Rect
import android.util.DisplayMetrics
import android.util.Log
import android.view.Gravity
import android.view.ViewGroup
import android.view.ViewTreeObserver
import android.view.WindowManager
import android.view.inputmethod.InputMethod.SHOW_FORCED
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import com.emedclouds.doctor.R
import com.emedclouds.doctor.widgets.OnTextInputCallback.Companion.ACTION_CANCEL
import com.emedclouds.doctor.widgets.OnTextInputCallback.Companion.ACTION_PUBLISH

interface OnTextInputCallback {
    companion object {
        const val ACTION_PUBLISH = "publish"
        const val ACTION_CANCEL = "cancel"
    }

    fun onInputFinish(text: String, action: String): Boolean
}

class CommonInputDialog {

    companion object {
        private const val TAG = "Input.CommonInputDialog"

        fun show(ctx: Activity, placeHolder: String, replyContent: String, commentContent: String, callback: OnTextInputCallback) {
            val inputView = InputView(ctx)
            inputView.setPlaceHolder(placeHolder)
            inputView.setTopHintText(replyContent)
            inputView.setInputText(commentContent)
            val dialog = object : Dialog(ctx, R.style.inputDialog) {
                override fun dismiss() {
                    callback.onInputFinish(inputView.text(), ACTION_CANCEL)
                    super.dismiss()
                }
            }
            val mainView = (ctx.findViewById(android.R.id.content) as ViewGroup).getChildAt(0)
            mainView.viewTreeObserver.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    val r = Rect()
                    if (mainView != null) {
                        mainView.getWindowVisibleDisplayFrame(r)
                        // check if the visible part of the screen is less than 85%
                        // if it is then the keyboard is showing
                        val newState = r.height().toDouble() / mainView.rootView.height.toDouble() < 0.85
                        if (!newState && dialog.isShowing) {
                            dialog.dismiss()
                            mainView.viewTreeObserver.removeGlobalOnLayoutListener(this)
                        }
                    }
                }
            })
            inputView.publish(Runnable {
                if (callback.onInputFinish(inputView.text(), ACTION_PUBLISH) && dialog.isShowing) {
                    dialog.dismiss()
                }
            })

            dialog.setCancelable(true)
            dialog.setContentView(inputView)

            dialog.window?.apply {
                setGravity(Gravity.BOTTOM)
                decorView.setPadding(0, 0, 0, 0)
                attributes.width = WindowManager.LayoutParams.MATCH_PARENT
                setBackgroundDrawable(null)
            }
            dialog.show()

            val mEditText = dialog.findViewById<EditText>(R.id.mEditText)
            mEditText.isFocusable = true
            mEditText.isFocusableInTouchMode = true
            mEditText.requestFocus()

            val imm: InputMethodManager? = ctx.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager?
            if (imm != null && imm.isActive) {
                imm.showSoftInput(mEditText, SHOW_FORCED)
//                imm.toggleSoftInput(InputMethodManager.SHOW_IMPLICIT, InputMethodManager.HIDE_NOT_ALWAYS)
            }
        }
    }
}