package com.whattowear.what_to_wear_flutter

import android.content.Context
import com.umeng.commonsdk.UMConfigure
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.whattowear.what_to_wear_flutter/umeng"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "agreePrivacy") {
                // 保存同意状态
                val sharedPreferences = getSharedPreferences("AppPreferences", Context.MODE_PRIVATE)
                sharedPreferences.edit().putBoolean("agreed_privacy", true).apply()
                
                // 初始化友盟
                UMConfigure.init(this, "699b155d6f259537c7605e61", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "380d2a709e32c787e49f26118be27db3")
                UMConfigure.setLogEnabled(BuildConfig.DEBUG)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // 确保App退出时保存统计数据
        // UMConfigure.onKillProcess(this) // Removed MobclickAgent usage due to missing analytics dependency
    }
}
