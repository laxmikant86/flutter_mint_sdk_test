package com.example.mintsamplle

import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.TaskStackBuilder
import androidx.databinding.DataBindingUtil
import com.example.mintsamplle.databinding.ActivitySdkInitBinding
import investwell.sdk.MintSDK
import io.flutter.embedding.android.FlutterActivity

class MintSDKInit: FlutterActivity() {
    lateinit var binding: ActivitySdkInitBinding
    private var  isInintiated:Boolean?=false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this@MintSDKInit,R.layout.activity_sdk_init)
//        setContentView(R.layout.activity_sdk_init)
        getBundles()
    }
    private fun getBundles(){
       if (intent !=null && intent.hasExtra("route") /*&& isInintiated != true*/){
           val domain :String = intent.getStringExtra("domain")!!
           val fcm :String= intent.getStringExtra("fcm")!!
           val sso :String= intent.getStringExtra("sso")!!
           isInintiated= true
           invokeSDK(sso = sso, fcmToken = fcm, domain = domain)

       }else{
           // remove activity
//           finish()
       }
    }

    private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${this@MintSDKInit.packageName}.MintSDKInit") {
        val mintSdk = MintSDK(this@MintSDKInit)
        mintSdk.invokeMintSDKForFlutter(sso = sso, token =fcmToken, domain = domain)
    }

    override fun onBackPressed() {
        super.onBackPressed()
        removeAllKeys()
        finish()
    }


    private fun checkBackStack(){
        val taskStackBuilder = TaskStackBuilder.create(this@MintSDKInit)
        taskStackBuilder.addNextIntentWithParentStack(
            Intent(this@MintSDKInit, MainActivity::class.java)
        )
        taskStackBuilder.startActivities()
    }
    override fun onPause() {
        super.onPause()
        removeAllKeys()
    }

    override fun onDestroy() {
        super.onDestroy()
        removeAllKeys()
    }

    private fun removeAllKeys(){
        if (intent.hasExtra("route")){
            intent.removeExtra("route")
//            intent.removeFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        }
    }

}