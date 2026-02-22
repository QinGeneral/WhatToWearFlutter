# UMeng Proguard Rules
-keep class com.umeng.** {*;}
-keep class com.uc.** {*;}
-keep class com.zui.** {*;}
-keep class com.miui.** {*;}
-keep class com.heytap.** {*;}
-keep class a.a.** {*;}
-keep class com.vivo.** {*;}
-keep class com.oplus.** {*;}
-keep class com.coloros.** {*;}
-keep class com.sec.android.** {*;}
-keep class com.huawei.** {*;}
-keep class com.hihonor.** {*;}
-keep class org.repackage.** {*;}
-keep class com.uyumao.** {*;}
-keep class com.ta.utdid2.** {*;}
-keep class com.ut.device.** {*;}
-keep class org.android.agoo.** {*;}
-keep class org.android.spdy.** {*;}

-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep public class com.whattowear.what_to_wear_flutter.R$*{
    public static final int *;
}
