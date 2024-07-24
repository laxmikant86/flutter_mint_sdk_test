package com.example.mintsamplle

import android.content.Intent
import android.os.Build
import android.os.Bundle
import investwell.activity.SplashActivity
import investwell.sdk.MintSDK
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONException
import org.json.JSONObject
import java.lang.Exception
class MainActivity: FlutterActivity() {

    private val CHANNEL = "mint-android-app"

    override fun onCreate(savedInstanceState: Bundle?) {
        // Aligns the Flutter view vertically with the window.
//        WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }

        super.onCreate(savedInstanceState)

        // mintSDK Invoke

        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        flutterEngine?.dartExecutor?.binaryMessenger?.let {  MethodChannel(it,CHANNEL).setMethodCallHandler { call, result ->

            if (call.method == "openMintLib") {
                try {
                    var domain =""
                    var sso =""
                    var fcm =""
                    val argumentsString: String? = call.arguments?.toString()
                    val tokenResponse = JSONObject(call.arguments.toString())
                    if (tokenResponse.toString().isEmpty()){
                        argumentsString.let { jsonString->
                            try {
                                val newResponse = JSONObject(jsonString)
                                domain = newResponse.optString("domain")
                                sso = newResponse.optString("ssoToken")
                                fcm = newResponse.optString("fcmToken")
                            }catch (e:Exception){e.printStackTrace()}
                        }
                    }else{
                        domain = tokenResponse.optString("domain")
                        sso = tokenResponse.optString("ssoToken")
                        fcm = tokenResponse.optString("fcmToken")
                    }
                    //invokeSDK(sso,fcm,domain)
                    val intentsdk = Intent(this@MainActivity, MintSDKInit::class.java)
                    intentsdk.putExtra("route","main")
                    intentsdk.putExtra("sso",sso)
                    intentsdk.putExtra("domain",domain)
                    intentsdk.putExtra("fcm",fcm)
                    startActivity(intentsdk)

                    result.success("Success")
                }catch (e: JSONException) {
                    // Handle JSON parsing error
                    result.error("JSON Parsing Error", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        } }

    }



}


