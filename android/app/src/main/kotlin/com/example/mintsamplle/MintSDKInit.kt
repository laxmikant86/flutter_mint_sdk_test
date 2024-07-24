package com.example.mintsamplle

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import com.example.mintsamplle.databinding.ActivitySdkInitBinding
import investwell.sdk.MintSDK
import io.flutter.embedding.android.FlutterActivity

class MintSDKInit: FlutterActivity() {
    lateinit var binding: ActivitySdkInitBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this@MintSDKInit,R.layout.activity_sdk_init)
//        setContentView(R.layout.activity_sdk_init)
        getBundles()
    }
    private fun getBundles(){
       if (intent !=null && intent.hasExtra("route")){
           val domain :String = intent.getStringExtra("domain")!!
           val fcm :String= intent.getStringExtra("fcm")!!
           val sso :String= intent.getStringExtra("sso")!!
           invokeSDK(sso = sso, fcmToken = fcm, domain = domain)
       }else{
           // remove activity
           finish()
       }
    }

    private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${this@MintSDKInit.packageName}.MintSDKInit") {
        val mintSdk = MintSDK(this@MintSDKInit)
        mintSdk.invokeMintSDKForFlutter(sso,fcmToken,domain)
    }

    override fun onBackPressed() {
        super.onBackPressed()
        finish()
    }
}