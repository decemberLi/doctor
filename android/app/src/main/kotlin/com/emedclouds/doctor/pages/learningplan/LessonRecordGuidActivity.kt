package com.emedclouds.doctor.pages.learningplan

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.emedclouds.doctor.R
import kotlinx.android.synthetic.main.activity_lesson_guide_layout.*

class LessonRecordGuidActivity : AppCompatActivity() {

    companion object {
        private const val keyCacheSuffix = "suffix"
        const val keyLessonRefsName = "lesson_record_refs"
        fun getCacheKey(suffix: String?) = "record_$suffix"

        fun startGuide(act: Activity, userId: String) {
            val intent = Intent(act, LessonRecordGuidActivity::class.java)
            intent.putExtra(keyCacheSuffix, userId)
            act.startActivity(intent)
        }

    }

    private val resArr = arrayOf(
            R.mipmap.lesson_record_guide1,
            R.mipmap.lesson_record_guide2,
            R.mipmap.lesson_record_guide3
    )
    private var idx = 0


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_lesson_guide_layout)
        btnPreStep.setOnClickListener {
            btnNextStep.visibility = View.VISIBLE
            nowUse.visibility = View.GONE
            if (--idx <= 0) {
                btnPreStep.visibility = View.GONE
                idx = 0
            } else {
                btnPreStep.visibility = View.VISIBLE
            }
            imageContent.setImageResource(resArr[idx])
        }
        btnNextStep.setOnClickListener {
            btnPreStep.visibility = View.VISIBLE
            nowUse.visibility = View.GONE
            if (++idx >= resArr.size - 1) {
                idx = resArr.size - 1
                nowUse.visibility = View.VISIBLE
                btnNextStep.visibility = View.GONE
                nowUse.setOnClickListener {
                    val refs = getSharedPreferences(keyLessonRefsName, MODE_PRIVATE)
                    refs.edit()
                            .putBoolean(getCacheKey(intent?.getStringExtra(keyCacheSuffix)), true)
                            .apply()
                    finish()
                }
            } else {
                btnNextStep.visibility = View.VISIBLE
            }
            imageContent.setImageResource(resArr[idx])
        }
        btnPreStep.visibility = View.GONE
    }

}