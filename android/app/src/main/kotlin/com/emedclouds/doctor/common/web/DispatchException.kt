package com.emedclouds.doctor.common.web

class DispatchException(private val code: Int, private val msg: String) : Exception(msg) {

    fun code(): Int {
        return code
    }

    fun msg(): String {
        return msg
    }
}