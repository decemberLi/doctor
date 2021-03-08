package com.emedclouds.doctor.utils

import android.content.Context
import android.content.SharedPreferences


fun refs(
        context: Context,
        name: String = "emedclouds_def_refs"
): SharedPreferences {
    return context.getSharedPreferences(name, Context.MODE_PRIVATE)
}

const val KEY_REFS_USER_ID = "key_refs_user_id"

