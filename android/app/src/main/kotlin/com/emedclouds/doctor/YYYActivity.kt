package com.emedclouds.doctor

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity

class YYYActivity : ComponentActivity() {
    companion object {
        const val TAG = "YYYActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = Intent(this, MainActivity::class.java)
        startActivity(intent)
        Log.w(TAG, "onCreate: OK")
        finish()
    }
}