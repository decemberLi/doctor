package com.emedclouds.doctor.utils

import android.Manifest.permission.*
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager.PERMISSION_GRANTED
import android.os.Build
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.content.ContextCompat.checkSelfPermission


const val REQUEST_CODE_SCREEN_RECORD_PERMISSION = 1000
const val REQUEST_CODE_MIC_PERMISSION = 1001
const val REQUEST_CODE_CAMERA_PERMISSION = 1002
const val REQUEST_CODE_EXTERNAL_STORAGE_PERMISSION = 1003

fun checkExternalPermission(ctx: Context): Boolean {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        return (checkSelfPermission(ctx, WRITE_EXTERNAL_STORAGE) == PERMISSION_GRANTED &&
                checkSelfPermission(ctx, READ_EXTERNAL_STORAGE) == PERMISSION_GRANTED)
    }
    return true
}

fun requestExternalStoragePermission(act: Activity, reqCode: Int) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        val permissions = arrayOf(WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE)
        requestPermissions(act, permissions, reqCode)
    }
}

fun checkMicPermission(ctx: Context): Boolean {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        return checkSelfPermission(ctx, RECORD_AUDIO) == PERMISSION_GRANTED
    }

    return true
}

fun checkCameraPermission(ctx: Context): Boolean {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        return checkSelfPermission(ctx, CAMERA) == PERMISSION_GRANTED
    }

    return true
}

fun requestCameraPermission(act: Activity, reqCode: Int) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        requestPermissions(act, arrayOf(CAMERA), reqCode)
    }
}

fun requestMicPermission(act: Activity, reqCode: Int) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        requestPermissions(act, arrayOf(RECORD_AUDIO), reqCode)
    }
}
