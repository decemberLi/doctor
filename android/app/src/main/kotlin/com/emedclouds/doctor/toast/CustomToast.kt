package com.emedclouds.doctor.toast

import android.content.Context
import android.text.TextUtils
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.StringRes
import com.emedclouds.doctor.R

class CustomToast {

    companion object {
        fun show(context: Context, @StringRes str: Int) {
            val view: View = LayoutInflater.from(context).inflate(R.layout.view_custom_toast, null)
            val msgView: TextView = view.findViewById(R.id.custom_toast_text) as TextView
            msgView.setText(str)
            val toast = Toast(context)
            toast.setGravity(Gravity.CENTER, 0, 20)
            toast.duration = Toast.LENGTH_LONG
            toast.view = view
            toast.show()
        }

        fun showSuccessToast(context: Context, @StringRes str: Int) {
            val view: View = LayoutInflater.from(context).inflate(R.layout.view_custom_toast, null)
            val msgView: TextView = view.findViewById(R.id.custom_toast_text) as TextView
            msgView.setText(str)
            val toast = Toast(context)
            toast.setGravity(Gravity.CENTER, 0, 20)
            toast.duration = Toast.LENGTH_LONG
            toast.view = view
            toast.show()
        }

        fun showFailureToast(context: Context, @StringRes str: Int) {
            val view: View = LayoutInflater.from(context).inflate(R.layout.view_custom_toast, null)
            view.findViewById<ImageView>(R.id.iconToast).apply {
                setImageResource(R.mipmap.icon_toast_error)
            }
            val msgView: TextView = view.findViewById(R.id.custom_toast_text) as TextView
            msgView.setText(str)
            val toast = Toast(context)
            toast.setGravity(Gravity.CENTER, 0, 20)
            toast.duration = Toast.LENGTH_LONG
            toast.view = view
            toast.show()
        }

        fun showFailureToast(context: Context, str: String) {
            val view: View = LayoutInflater.from(context).inflate(R.layout.view_custom_toast, null)
            view.findViewById<ImageView>(R.id.iconToast).apply {
                setImageResource(R.mipmap.icon_toast_error)
            }
            val msgView: TextView = view.findViewById(R.id.custom_toast_text) as TextView
            msgView.text = str
            val toast = Toast(context)
            toast.setGravity(Gravity.CENTER, 0, 20)
            toast.duration = Toast.LENGTH_LONG
            toast.view = view
            toast.show()
        }

        fun toast(context: Context, str: String) {
            val rootView: View = LayoutInflater.from(context).inflate(R.layout.view_custom_simple_toast, null)
            rootView.findViewById<TextView>(R.id.simple_toast_textView).apply {
                text = if (TextUtils.isEmpty(str)) "" else str
            }
            Toast(context)
                    .apply {
                        duration = Toast.LENGTH_LONG
                        setGravity(Gravity.CENTER, 0, 20)
                        view = rootView
                    }.show()
        }
    }
}