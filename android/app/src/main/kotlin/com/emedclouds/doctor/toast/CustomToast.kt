package com.emedclouds.doctor.toast

import android.content.Context
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.StringRes
import com.emedclouds.doctor.R

class CustomToast {

    companion object {
        fun show(context: Context,@StringRes str: Int) {
            val view: View = LayoutInflater.from(context).inflate(R.layout.view_custom_toast, null)
            val msgView: TextView = view.findViewById(R.id.custom_toast_text) as TextView
            msgView.setText(str)
            val toast = Toast(context)
            toast.setGravity(Gravity.BOTTOM or Gravity.CENTER, 0, 20)
            toast.duration = Toast.LENGTH_LONG
            toast.view = view
            toast.show()
        }
    }
}