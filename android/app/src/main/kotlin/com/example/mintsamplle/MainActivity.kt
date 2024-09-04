package com.example.mintsamplle

import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.WindowManager
import android.widget.Toast
import androidx.core.app.TaskStackBuilder
import androidx.fragment.app.DialogFragment
import investwell.activity.SplashActivity
import investwell.sdk.MintSDK
import investwell.utils.AppSession
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONException
import org.json.JSONObject
import java.lang.Exception
class MainActivity: FlutterFragmentActivity() {

    private val CHANNEL = "mint-android-app"
    private var msession: AppSession?= null



    override fun onCreate(savedInstanceState: Bundle?) {
        // Aligns the Flutter view vertically with the window.
//        WindowCompat.setDecorFitsSystemWindows(getWindow(), false)
        showToast("OnCreate")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }
        msession = AppSession(this@MainActivity)
        super.onCreate(savedInstanceState)

        // mintSDK Invoke
//        invoke()
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
//                    invokeSDK(sso,fcm,domain)
//                    invoke(sso, fcmToken = fcm, domain = domain)
                    val taskStackBuilder = TaskStackBuilder.create(this@MainActivity)
                    val intentsdk = Intent(this@MainActivity, MintSDKInit::class.java)
                    intentsdk.putExtra("route","main")
                    intentsdk.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP)
                    intentsdk.putExtra("sso",sso)
                    intentsdk.putExtra("domain",domain)
                    intentsdk.putExtra("fcm",fcm)
//                    startActivity(intentsdk)
                    taskStackBuilder.addNextIntentWithParentStack(intentsdk)
                    taskStackBuilder.startActivities()

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

    override fun onStart() {
        showToast("onStart")
        super.onStart()
    }

    override fun onResume() {
        showToast("onResume")
        super.onResume()
    }

    override fun onRestart() {
        showToast("onRestart")
        super.onRestart()
    }

    override fun onPause() {
        showToast("onPause")
        super.onPause()
    }

    override fun onStop() {
        showToast("onStop")
        super.onStop()
    }

    override fun onDestroy() {
        showToast("onDestroy")
        super.onDestroy()
    }


fun showToast(message:String?){
    println("SDK App --> $message")
    Toast.makeText(this@MainActivity,"SDK App --> $message",Toast.LENGTH_SHORT).show()
}

    private fun  invoke(
        sso: String?,
        fcmToken: String?,
        domain: String?
        ){
        val dialog = MintSDKDialog(this@MainActivity,
            sso =sso,
            fcmToken =fcmToken,
            domain = domain)
        dialog.show()
    }

}




class MintSDKDialog(val mContext: Context,
                    val sso:String?,
    val fcmToken:String?,
    val domain:String?):Dialog(mContext){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        setContentView(R.layout.activity_sdk_init)

        val mintSdk = MintSDK(context = mContext)
        mintSdk.invokeMintSDKForFlutter(sso = sso!!, token =fcmToken!!, domain = domain!!)

    }


    override fun onStart() {
        super.onStart()
        val window = window
        window?.setLayout(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT
        )
    }
}
