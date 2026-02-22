package com.whattowear.what_to_wear_flutter

import android.app.Application
import com.umeng.commonsdk.UMConfigure

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // SDK预初始化函数不会采集设备信息，也不会向友盟后台上报数据。
        // preInit预初始化函数耗时极少，不会影响App首次冷启动用户体验
        UMConfigure.preInit(this, "699b155d6f259537c7605e61", "Umeng")

        val sharedPreferences = getSharedPreferences("AppPreferences", MODE_PRIVATE)
        val agreedPrivacy = sharedPreferences.getBoolean("agreed_privacy", false)
        
        if (agreedPrivacy) {
            // 如果用户已经同意了隐私政策，直接初始化
            UMConfigure.init(this, "699b155d6f259537c7605e61", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "380d2a709e32c787e49f26118be27db3")
            UMConfigure.setLogEnabled(BuildConfig.DEBUG)
        }
    }
}
