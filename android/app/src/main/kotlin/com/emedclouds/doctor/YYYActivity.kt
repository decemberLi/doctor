package com.emedclouds.doctor

import android.content.Intent
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import androidx.activity.ComponentActivity

class YYYActivity : ComponentActivity() {
    companion object {
        const val TAG = "YYYActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val openIntent = Intent(this, MainActivity::class.java)
        val extra = intent.getStringExtra("extras")
        if (TextUtils.isEmpty(extra) || extra?.trim()?.length == 0) {
            finish()
            return
        }
        openIntent.putExtra("extras", extra)
        startActivity(openIntent)
        Log.w(TAG, "onCreate: OK")
        finish()
    }
}