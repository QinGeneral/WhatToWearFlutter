package com.whattowear.what_to_wear_flutter

import android.app.Application
import com.umeng.commonsdk.UMConfigure

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // SDK预初始化函数不会采集设备信息，也不会向友盟后台上报数据。
        // preInit预初始化函数耗时极少，不会影响App首次冷启动用户体验
        UMConfigure.preInit(this, "699b155d6f259537c7605e61", "Umeng")
    }
}
