package com.example.mintsamplle

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

public class FlutterMintPlugin:FlutterPlugin ,MethodChannel.MethodCallHandler{

    private var channel: MethodChannel? = null

    private val CHANNEL = "mint-android-app"
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setupChannel(binding.binaryMessenger,binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    teardownChannel()
    }

    private fun setupChannel(messenger: BinaryMessenger, context: Context,) {
        channel = MethodChannel(messenger, CHANNEL,)
        val handler = MethodCallHandlerImpl(context,)
        channel?.setMethodCallHandler(handler,)
    }

    private fun teardownChannel() {
        channel?.setMethodCallHandler(null,)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("Hello from ")
    }

}