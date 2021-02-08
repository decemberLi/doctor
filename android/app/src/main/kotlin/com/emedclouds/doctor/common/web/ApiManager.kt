package com.emedclouds.doctor.common.web

import android.util.Log
import com.emedclouds.doctor.common.web.api.BaseApi
import java.util.*

class ApiManager {

    private val TAG = "YWeb.ApiManager"
    private val mApiMap: MutableMap<String, BaseApi> = hashMapOf()
    private val mDynamicApiMap:MutableMap<String,String> = hashMapOf()

    companion object {
        var instance = Holder.holder
    }

    private object Holder {
        val holder = ApiManager()
    }

    fun addApi(name: String, api: BaseApi) {
        synchronized(mApiMap) {
            mApiMap[name] = api
        }
    }

    fun removeApi(name: String): BaseApi? {
        synchronized(mApiMap) {
            return mApiMap.remove(name)
        }
    }

    fun removeAll(names: Array<String>) {
        synchronized(mApiMap) {
            for (each: String in names) {
                mApiMap.remove(each)
            }
        }
    }

    fun addApis(apis: Map<String, BaseApi>) {
        synchronized(mApiMap) {
            mApiMap.putAll(apis)
        }
    }

    fun dispatch(name: String, bizType: String, param: String?) {
        val api: BaseApi = mApiMap[name]
                ?: throw DispatchException(-2, "Method $name not implementation.")
        Log.d(TAG, "dispatch: ${mApiMap[name]}")
        api.jsCall(bizType, param)
    }

}